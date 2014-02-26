Gem::Specification.new do |s|
  s.name        = 'active_record_lite'
  s.version     = '0.1.0'
  s.summary     = "A custom clone of ActiveRecord."
  s.description = s.summary
  s.authors     = ["Will Hastings"]
  s.email       = 'will@objectdotcreate.net'
  s.files       = ["lib/active_record_lite.rb"]
  s.homepage    =
    'https://github.com/whastings/active_record_lite'
  s.add_dependency('sqlite3', ['~> 1.3'])
  s.add_dependency('activesupport', ['~> 4.0'])
end
