require File.dirname(__FILE__) + "/spec_helper"

describe Integrity do
  specify "root should point to the directory where all integrity files are located" do
    Integrity.root.should == File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end

  specify 'default configuration' do
    Integrity.default_configuration.should == { :database_uri => 'sqlite3::memory:',
      :export_directory => Integrity.root / 'exports',
      :log      => STDOUT,
      :base_uri => 'http://localhost:8910',
      :use_basic_auth => false
    }
  end

  describe 'When initializing' do
    before(:each) do
      DataMapper.stub!(:setup).with(:default, anything)
      Integrity.instance_variable_set(:@config, nil)
    end

    after(:each) do
      Integrity.instance_variable_set(:@config, nil)
    end

    it 'should use the default database configuration file unless otherwise specified' do
      DataMapper.should_receive(:setup).with(:default, 'sqlite3::memory:')
      Integrity.new
    end
  end

  describe 'Configuration' do
    it 'should default to default configuration' do
      Integrity.config.should == Integrity.default_configuration
    end

    describe 'When setting the configuration' do
      it 'should load the specified configuration file' do
        YAML.should_receive(:load_file).with('/etc/integrity.yml').
          and_return({ :blah => 1 })
        Integrity.config = '/etc/integrity.yml'
      end
    
      it "should error out if there's no config file" do
        lambda { Integrity.config = "i_dont_exist.yml" }.should raise_error(Errno::ENOENT)
      end
    end
  end

  describe "Logging" do
    before(:each) { Integrity.instance_variable_set(:@logger, nil) }

    it "should use Logger" do
      Integrity.logger.should be_an_instance_of(Logger)
    end

    it "should log to STDOUT by default" do
      Logger.should_receive(:new).with(STDOUT)
      Integrity.logger
    end
  end
end
