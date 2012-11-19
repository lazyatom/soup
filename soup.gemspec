# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "soup"
  s.version = "1.0.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Adam"]
  s.date = "2012-11-19"
  s.email = "james@lazyatom.com"
  s.extra_rdoc_files = ["README"]
  s.files = ["Manifest", "Rakefile", "README", "test/file_backend_test.rb", "test/multi_soup_backend_test.rb", "test/snip_test.rb", "test/soup_test.rb", "test/test_helper.rb", "test/test_helper_test.rb", "lib/soup", "lib/soup/backends", "lib/soup/backends/base.rb", "lib/soup/backends/file_backend.rb", "lib/soup/backends/memory.rb", "lib/soup/backends/multi_soup.rb", "lib/soup/backends/read_only.rb", "lib/soup/backends/yaml_backend.rb", "lib/soup/backends.rb", "lib/soup/empty_class.rb", "lib/soup/snip.rb", "lib/soup/test_helper.rb", "lib/soup.rb"]
  s.homepage = "http://lazyatom.com"
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "A super-simple data store"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<kintama>, [">= 0.1.11"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<kintama>, [">= 0.1.11"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<kintama>, [">= 0.1.11"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
