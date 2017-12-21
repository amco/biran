require 'singleton'

module Biran
  class Config
    include Singleton

    attr_writer :config_filename, :local_config_filename, :db_config_file_name,
                :secrets_filename, :config_dirname, :root_path, :use_capistrano,
                :db_config, :secrets, :root_path, :app_env, :base_dir

    def app_env
      return @app_env if @app_env
      @app_env = Rails.env if defined? Rails
      @app_env ||= 'development'
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

    def files_to_generate
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
      @root_path = Rails.root if defined? Rails
      @root_path ||= './'
    end
  end
end
