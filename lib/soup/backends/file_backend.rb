class Soup
  module Backends
    class FileBackend < Base
      def initialize(path="soup")
        @base_path = path
      end

      def prepare
        FileUtils.mkdir_p(@base_path)
      end

      def names
        snip_paths.map { |s| snip_name_from_path(s) }
      end

      def load_snip(name)
        path = snip_paths.find { |s| snip_name_from_path(s) == name }
        if path
          load_snip_from_path(path, name)
        else
          nil
        end
      end

      def save_snip(attributes)
        File.open(path_for(attributes[:name], attributes[:extension]), 'w') do |f|
          attributes_without_content = attributes.dup
          f.write attributes_without_content.delete(:content)
          f.write attributes_without_content.to_yaml.gsub(/^---\s/, "\n\n") if attributes_without_content.any?
        end
        Snip.new(attributes, self)
      end

      def destroy(name)
        path = path_for(name)
        if File.exist?(path)
          File.delete(path)
          true
        else
          nil
        end
      end

      def all_snips
        snip_paths.map do |path|
          load_snip_from_path(path, snip_name_from_path(path))
        end
      end

      private

      def snip_name_from_path(path)
        File.basename(path).split(".").first
      end

      def load_snip_from_path(path, name)
        snip = nil
        File.open(path) do |file|
          data = file.read
          default_attributes = {:name => name, :updated_at => file.mtime, :created_at => file.mtime}
          if attribute_start = data.index("\n:")
            content = data[0, attribute_start].strip
            attributes = default_attributes.merge(load_from_yaml(data[attribute_start, data.length]))
          else
            content = data
            attributes = default_attributes
          end
          attributes.update(:content => content) if content && content.length > 0
          extension = File.extname(path).gsub(/^\./, '')
          attributes.update(:extension => extension) if extension != "snip"
          snip = Snip.new(attributes, self)
        end
        snip
      end

      def path_for(name, extension=nil)
        snip_extension = ".snip"
        snip_extension += ".#{extension}" if extension
        File.join(@base_path, name + snip_extension)
      end

      def snip_paths
        Dir[File.join(@base_path, "*")].select { |s| File.file?(s) }
      end

      def load_from_yaml(yaml)
        if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1')
          YAML.load(yaml, permitted_classes: [Time, Symbol])
        else
          YAML.load(yaml)
        end
      end
    end
  end
end
