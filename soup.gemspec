# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{soup}
  s.version = "0.9.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Adam"]
  s.date = %q{2009-09-27}
  s.email = %q{james@lazyatom.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["Manifest", "Rakefile", "README", "test/soup_test.rb", "lib/soup", "lib/soup/empty_class.rb", "lib/soup/snip.rb", "lib/soup.rb"]
  s.homepage = %q{http://lazyatom.com}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{soup}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A super-simple data store}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
