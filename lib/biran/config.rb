require 'singleton'

module Biran
  class Config
    include Singleton

    def app_env
      return @app_env if @app_env
      return Rails.env if defined? Rails
      @app_env = 'development'
    end

    def base_dir
      @base_dir ||= ''
    end

    def config_filename
      @config_filename ||= 'app_config.yml'.freeze
    end

    def local_config_filename
      @local_config_filename ||= 'local_config.yml'.freeze
    end

    def db_config_filename
      @db_config_filename ||= 'db_config.yml'.freeze
    end

    def secrets_filename
      @secrets_filename ||= 'secrets.yml'.freeze
    end

    def config_dirname
      @config_dirname ||= 'config'.freeze
    end

    def use_capisrano
      @use_capistrano ||= false
    end

    def tasks
      @tasks ||= %i[vhost database]
    end

    def config_tasks
      {
        vhost: {extension: '.conf'},
        database: {extension: '.yml'}
      }
    end

    def db_config
      @db_config ||= {}
    end

    def secrets
      @secrets ||= {}
    end

    def app_setup_blocks
      @app_setup_blocks ||= %i[app].freeze
    end

    def bindings
      @bindings ||= %i[db_config]
    end

    def root_path
      return @root_path if @root_path
      return Rails.root if defined? Rails
      @root_path ||= './'
    end
  end
end
