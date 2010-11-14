BASE_DIR = File.dirname(__FILE__)

require BASE_DIR + '/ruby/Configurator'
require 'spec/rake/spectask'

task :test do
    test_files = Dir[BASE_DIR + '/test/unit/*Test.rb']
    exit_statuses = []

    test_files.each do |test_file|
        puts "Running '#{test_file.gsub(BASE_DIR + '/test/unit/', '')}'"
        Process.fork { load test_file }
        Process.wait
        exit_statuses << $?
    end

    if exit_statuses.collect(&:success?).include?(false)
        raise "Some tests failed."
    end
end

spec_prereq = []

desc 'Run all specs in spec directory'
Spec::Rake::SpecTask.new(:spec => spec_prereq) do |t|
  t.spec_opts = ['--options', "\"#{ROOTDIR}/spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*/*_spec.rb']
end
