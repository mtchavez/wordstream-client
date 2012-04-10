Gem::Specification.new do |s|
  s.name             = 'wordstream-client'
  s.version          = '0.0.1'
  s.date             = '2012-04-07'
  s.summary          = "Wordstream API Wrapper"
  s.description      = "Wraps Wordstream API calls in a gem."
  s.authors          = ['Chavez']
  s.email            = ''
  s.files            = ['lib/wordstream-client.rb', 'lib/wordstream-client/config.rb', 'lib/wordstream-client/client.rb', 'lib/wordstream-client/exceptions.rb', 'lib/wordstream-client/auth.rb']
  s.require_paths    = ['lib']
  s.homepage         = 'http://github.com/mtchavez/wordstream-client'
  s.rdoc_options     = ['--charset=UTF-8 --main=README.md']
  s.extra_rdoc_files = ['README.md']

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, ['>= 1.6.7'])
      s.add_runtime_dependency(%q<rspec>, ['>= 2.0'])
    else
      s.add_dependency(%q<rest-client>, ['>= 1.6.7'])
      s.add_dependency(%q<rspec>, ['>= 2.0'])
    end
  else
    s.add_dependency(%q<rest-client>, ['>= 1.6.7'])
    s.add_dependency(%q<rspec>, ['>= 2.0'])
  end

end
