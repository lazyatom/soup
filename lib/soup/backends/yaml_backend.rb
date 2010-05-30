class Soup
  module Backends
    class YAMLBackend
      ATTRIBUTE_TOKEN = "--- # Soup attributes"

      def initialize(path="soup")
        @base_path = path
      end

      def prepare
        FileUtils.mkdir_p(@base_path)
      end

      def all_snips
        Dir[path_for("*")].map do |key|
          load_snip(File.basename(key, ".yml"))
        end
      end

      def find(conditions)
        if conditions.keys == [:name]
          load_snip(conditions[:name])
        else
          all_snips.select do |s|
            conditions.inject(true) do |matches, (key, value)|
              matches && (s.__send__(key) == value)
            end
          end
        end
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
          content = attributes.delete(:content)
          f.write content
          f.write attributes.to_yaml.gsub(/^---\s/, ATTRIBUTE_TOKEN) if attributes.any?
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

      def path_for(name)
        File.join(@base_path, name + ".yml")
      end
    end
  end
end