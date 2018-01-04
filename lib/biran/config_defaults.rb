module Biran
  module ConfigDefaults
    def configuration
      Config.instance
    end

    def app_defaults_init
      {
        app: {
          root_path: configuration.root_path,
          shared_dir: configuration.shared_dir,
          base_dir: configuration.base_dir,
          use_capistrano: configuration.use_capistrano,
          files_to_generate: configuration.files_to_generate,
          db_config: configuration.db_config,
          secrets: configuration.secrets,
          bindings: configuration.bindings
        }
      }
    end

    def app_base
      @app_base ||= ENV['BIRAN_APP_BASE_PATH'] || app_config_defaults[:app][:base_path] || app_config_defaults[:app][:root_path]
    end

    def app_root
      return File.join(app_base, 'current') if use_capistrano?
      app_base
    end

    def app_shared_dir
      return File.join(app_base, 'shared') if use_capistrano?
      app_base
    end

    def bindings
      app_config_defaults[:app][:bindings]
    end

    def config_dir
      File.join configuration.root_path, configuration.config_dirname
    end

    def local_config_file
      ENV['BIRAN_LOCAL_CONFIG_FILE'] ||
        File.join(app_shared_dir, configuration.config_dirname, configuration.local_config_filename)
    end

    def db_config_override_file
      File.join(app_shared_dir, configuration.config_dirname, configuration.db_config_filename)
    end

    def secrets_file
      File.join(configuration.root_path, configuration.config_dirname, configuration.secrets_filename)
    end

    def default_db_config_file
      Rails.root.join(configuration.config_dirname, configuration.db_config_filename)
    end

    def use_capistrano?
      # Implement in consumer class
    end
  end
end
