require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = Dir['test/**/*_test.rb']
  t.libs << 'test'
end

desc 'Run tests'
task :default => :test
