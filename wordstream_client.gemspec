Gem::Specification.new do |s|
  s.name              = 'wordstream_client'
  s.version           = '0.0.5'
  s.date              = '2012-10-15'
  s.summary           = 'Wordstream API Wrapper'
  s.description       = 'Wraps Wordstream API calls in a gem.'
  s.authors           = ['Chavez']
  s.email             = ''
  s.files             = Dir.glob("{bin,lib}/**/*") + %w[README.md]
  s.require_paths     = ['lib']
  s.homepage          = 'http://github.com/mtchavez/wordstream-client'
  s.rdoc_options      = ['--charset=UTF-8 --main=README.md']
  s.extra_rdoc_files  = ['README.md']

  s.add_dependency(%q<rest-client>, ['>= 1.6.7'])
  s.add_development_dependency(%q<rspec>, ['>= 2.0'])
  s.add_development_dependency(%q<simplecov>)
end
