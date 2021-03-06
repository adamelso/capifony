require 'spec_helper'

describe "Capifony::Symfony2" do
  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend(Capistrano::Spec::ConfigurationExtension)

    # Common parameters
    @configuration.set :maintenance_basename, 'maintenance'

    Capifony::Symfony2.load_into(@configuration)
  end

  it "defines global variables" do
    @configuration.fetch(:symfony_env_local).should == 'dev'
    @configuration.fetch(:symfony_env_prod).should == 'prod'
    @configuration.fetch(:php_bin).should == 'php'
    @configuration.fetch(:remote_tmp_dir).should == '/tmp'
  end

  it "defines Symfony2 related variables" do
    @configuration.fetch(:app_path).should == 'app'
    @configuration.fetch(:web_path).should == 'web'
    @configuration.fetch(:use_symfony_3_dirs).should == false
    @configuration.fetch(:symfony_console).should == 'app/console'
    @configuration.fetch(:log_path).should == 'app/logs'
    @configuration.fetch(:cache_path).should == 'app/cache'
    @configuration.fetch(:shared_children).should == ['app/logs', 'web/uploads']
    @configuration.fetch(:asset_children).should == ['web/css', 'web/images', 'web/js']
    @configuration.fetch(:writable_dirs).should == ['app/logs', 'app/cache']
    @configuration.fetch(:controllers_to_clear).should == ['app_*.php']
  end

  it "defines Symfony3 related variables" do
    @configuration.set :use_symfony_3_dirs, true

    Capifony::Symfony2.load_into(@configuration)

    @configuration.fetch(:app_path).should == 'app'
    @configuration.fetch(:web_path).should == 'web'
    @configuration.fetch(:var_path).should == 'var'
    @configuration.fetch(:bin_path).should == 'bin'
    @configuration.fetch(:use_symfony_3_dirs).should == true
    @configuration.fetch(:symfony_console).should == 'bin/console'
    @configuration.fetch(:log_path).should == 'var/logs'
    @configuration.fetch(:cache_path).should == 'var/cache'
    @configuration.fetch(:shared_children).should == ['var/logs', 'web/uploads']
    @configuration.fetch(:asset_children).should == ['web/css', 'web/images', 'web/js']
    @configuration.fetch(:writable_dirs).should == ['var/logs', 'var/cache']
    @configuration.fetch(:controllers_to_clear).should == ['app_*.php']
  end


end
