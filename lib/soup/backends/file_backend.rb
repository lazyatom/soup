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
        snip_paths.map { |s| File.basename(s).split(".").first }
      end

      def load_snip(name)
        path = snip_paths.find { |s| File.basename(s).split(".").first == name }
        if path
          file = File.new(path)
          data = file.read
          default_attributes = {:name => name, :updated_at => file.mtime, :created_at => file.mtime}
          if attribute_start = data.index("\n:")
            content = data[0, attribute_start].strip
            attributes = default_attributes.merge(YAML.load(data[attribute_start, data.length]))
          else
            content = data
            attributes = default_attributes
          end
          attributes.update(:content => content) if content && content.length > 0
          extension = File.extname(path).gsub(/^\./, '')
          attributes.update(:extension => extension) if extension != "snip"
          Snip.new(attributes, self)
        else
          nil
        end
      end

      def save_snip(attributes)
        File.open(path_for(attributes[:name], attributes[:extension]), 'w') do |f|
          attributes_without_content = attributes.dup
          f.write attributes_without_content.delete(:content)
          f.write attributes_without_content.to_yaml.gsub(/^---\s/, "\n") if attributes_without_content.any?
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

      private

      def path_for(name, extension=nil)
        snip_extension = ".snip"
        snip_extension += ".#{extension}" if extension
        File.join(@base_path, name + snip_extension)
      end

      def snip_paths
        Dir[File.join(@base_path, "*")].select { |s| File.file?(s) }
      end

      def all_snips
        Dir[File.join(@base_path, "*")].map do |key|
          load_snip(File.basename(key, ".snip"))
        end
      end
    end
  end
end