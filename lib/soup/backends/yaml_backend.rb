class Soup
  module Backends
    class YAMLBackend < Base
      ATTRIBUTE_TOKEN = "--- # Soup attributes"

      def initialize(path="soup")
        @base_path = path
      end

      def prepare
        FileUtils.mkdir_p(@base_path)
      end

      def names
        Dir[path_for("*")].map { |s| File.basename(s, ".yml") }
      end

      def load_snip(name)
        path = path_for(name)
        if File.exist?(path)
          file = File.read(path)
          if attribute_start = file.index(ATTRIBUTE_TOKEN)
            content = file.slice(0...attribute_start)
            attributes = {:name => name}.merge(YAML.load(file.slice(attribute_start..-1)).merge(:content => content))
          else
            attributes = {:content => file, :name => name}
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
          f.write attributes_without_content.to_yaml.gsub(/^---\s/, ATTRIBUTE_TOKEN) if attributes_without_content.any?
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
        File.join(@base_path, name + ".yml")
      end

      def all_snips
        Dir[path_for("*")].map do |key|
          load_snip(File.basename(key, ".yml"))
        end
      end
    end
  end
end