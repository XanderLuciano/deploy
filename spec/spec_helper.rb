require 'tmpdir'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each{ |f| require f }

RSpec.configure do |config|
  config.include CliSupport
  config.include DeploySupport
  config.include FileSystemSupport
  config.include HostSupport

  config.add_setting :umask

  config.before :suite do
    RSpec.configuration.umask = `ssh $USER@localhost umask`.strip.to_i(8)
  end

  config.around :each do |example|
    Dir.mktmpdir do |deployer_tmp|
      Dir.mktmpdir do |server_tmp|
        @deployer_tmp = deployer_tmp
        @server_tmp = server_tmp
        example.run
      end
    end
  end
end
