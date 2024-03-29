module Biran
  module ConfigDefaults
    def configuration
      Config.instance
    end

    def app_defaults_init
      {
        app: {
          base_path: configuration.base_path,
          shared_dir: configuration.shared_dir,
          base_dir: configuration.base_dir,
          use_capistrano: configuration.use_capistrano,
          bindings: configuration.bindings,
          vhost_public_dirname: configuration.vhost_public_dirname
        },
        db_config: configuration.db_config,
        secrets: configuration.secrets,
      }
    end

    def app_env
      app_env = ENV['BIRAN_APP_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || configuration.app_env
      sanitize_input(app_env)
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

    def config_dirname
      sanitize_input(configuration.config_dirname)
    end

    def config_dir
      File.join(configuration.base_path, config_dirname)
    end

    def local_config_file
      ENV['BIRAN_LOCAL_CONFIG_FILE'] ||
        File.join(app_shared_dir, config_dirname, local_config_filename)
    end

    def local_config_filename
      filename= ENV['BIRAN_LOCAL_CONFIG_FILENAME'] || app_config_defaults[:app][:local_config_filename] || configuration.local_config_filename
      sanitize_input( filename )
    end

    def extra_config_suffix
      suffix = ENV['BIRAN_EXTRA_CONFIG_SUFFIX'] || app_config_defaults[:app][:extra_config_suffix] || configuration.extra_config_suffix
      sanitize_input( suffix )
    end

    def extra_config_file
      File.join(config_dirname, app_config_filename.gsub(/\.yml$/, "_#{extra_config_suffix}.yml"))
    end

    def app_config_filename
      sanitize_input(configuration.config_filename)
    end

    def app_config_file
      File.join(config_dirname, app_config_filename)
    end

    def vhost_public_dirname
      pub_dir_name = ENV['BIRAN_VHOST_PUBLIC_DIRNAME'] || app_config_defaults[:app][:vhost_public_dirname]
      sanitize_input(pub_dir_name)
    end

    def db_config_override_file
      File.join(app_shared_dir, config_dirname, db_config_filename)
    end

    def db_config_filename
       filename = app_config_defaults[:app][:db_config_filename] || configuration.db_config_filename
       sanitize_input(filename)
    end

    def secrets_file
      File.join(configuration.base_path, config_dirname, secrets_filename)
    end

    def secrets_filename
      filename = app_config_defaults[:app][:secrets_filename] || configuration.secrets_filename
      sanitize_input(filename)
    end

    def default_db_config_file
      File.join(config_dir, db_config_filename)
    end

    def use_capistrano?
      # Implement in consumer class
    end

    def sanitize_input string
      # Borrowed from ActiveStorage
      string.encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "ï¿½").strip.tr("\u{202E}%$|:;/\t\r\n\\", "-")
    end
  end
end
