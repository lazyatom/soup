# -*- encoding: utf-8 -*-
# stub: soup 1.0.14 ruby lib

Gem::Specification.new do |s|
  s.name = "soup".freeze
  s.version = "1.0.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["James Adam".freeze]
  s.date = "2022-06-13"
  s.email = "james@lazyatom.com".freeze
  s.extra_rdoc_files = ["README".freeze]
  s.files = ["Manifest".freeze, "README".freeze, "Rakefile".freeze, "lib/soup".freeze, "lib/soup.rb".freeze, "lib/soup/backends".freeze, "lib/soup/backends.rb".freeze, "lib/soup/backends/base.rb".freeze, "lib/soup/backends/file_backend.rb".freeze, "lib/soup/backends/memory.rb".freeze, "lib/soup/backends/multi_soup.rb".freeze, "lib/soup/backends/read_only.rb".freeze, "lib/soup/backends/yaml_backend.rb".freeze, "lib/soup/empty_class.rb".freeze, "lib/soup/snip.rb".freeze, "lib/soup/test_helper.rb".freeze, "test/file_backend_test.rb".freeze, "test/multi_soup_backend_test.rb".freeze, "test/snip_test.rb".freeze, "test/soup_test.rb".freeze, "test/test_helper.rb".freeze, "test/test_helper_test.rb".freeze]
  s.homepage = "http://lazyatom.com".freeze
  s.rdoc_options = ["--main".freeze, "README".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "A super-simple data store".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<kintama>.freeze, [">= 0.1.11"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  else
    s.add_dependency(%q<kintama>.freeze, [">= 0.1.11"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
