# frozen_string_literal: true
require 'singleton'

module Biran
  class Config
    include Singleton

    attr_writer :config_filename, :local_config_filename, :db_config_filename,
                :secrets_filename, :config_dirname, :use_capistrano, :db_config,
                :secrets, :base_path, :app_env, :base_dir, :bindings, :app_setup_blocks,
                :extra_config_suffix

    attr_accessor :shared_dir

    def app_env
      return @app_env if @app_env
      @app_env = Rails.env if defined? Rails
      @app_env ||= 'development'
    end

    def base_dir
      @base_dir ||= ''
    end

    def config_filename
      @config_filename ||= 'app_config.yml'
    end

    def local_config_filename
      @local_config_filename ||= 'local_config.yml'
    end

    def db_config_filename
      @db_config_filename ||= 'db_config.yml'
    end

    def secrets_filename
      @secrets_filename ||= 'secrets.yml'
    end

    def config_dirname
      @config_dirname ||= 'config'
    end

    def vhost_public_dirname
      @vhost_public_dirname ||= 'public'
    end

    def use_capistrano
      @use_capistrano ||= false
    end

    def files_to_generate
      {
        vhost: {extension: '.conf'}
      }
    end

    def db_config
      @db_config ||= {}
    end

    def secrets
      @secrets ||= {}
    end

    def app_setup_blocks
      @app_setup_blocks ||= %i[app]
    end

    def bindings
      @bindings ||= %i[db_config]
    end

    def extra_config_suffix
      @extra_config_suffix ||= 'extras'
    end

    def base_path
      return @base_path if @base_path
      @base_path = Rails.root if defined? Rails
      @base_path ||= './'
    end
  end
end
