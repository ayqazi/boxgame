BASE_DIR = File.dirname(__FILE__)

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

task :spec do
    SPEC_CMD = ENV['SPEC_CMD'] || '/usr/local/ruby-1.9/bin/spec'
    system("#{SPEC_CMD} -O #{BASE_DIR}/spec/options #{BASE_DIR}/spec/")
end
