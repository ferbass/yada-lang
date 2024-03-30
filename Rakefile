require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/test_yada.rb'
  t.verbose = true
end

task default: :test
