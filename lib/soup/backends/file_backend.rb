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
        Dir[path_for("*")].map { |s| File.basename(s, ".snip") }
      end

      def load_snip(name)
        path = path_for(name)
        if File.exist?(path)
          file = File.new(path)
          data = file.read
          default_attributes = {:name => name, :updated_at => file.mtime, :created_at => file.ctime}
          if attribute_start = data.index("\n:")
            content = data[0, attribute_start].strip
            attributes = default_attributes.merge(YAML.load(data[attribute_start, data.length]).merge(:content => content))
          else
            attributes = default_attributes.merge(:content => data)
          end
          Snip.new(attributes, self)
        else
          nil
        end
      end

      def save_snip(attributes)
        File.open(path_for(attributes[:name]), 'w') do |f|
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

      def path_for(name)
        File.join(@base_path, name + ".snip")
      end

      def all_snips
        Dir[path_for("*")].map do |key|
          load_snip(File.basename(key, ".snip"))
        end
      end
    end
  end
end