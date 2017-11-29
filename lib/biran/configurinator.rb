module Biran
  class Configurinator
    include ConfigDefaults

    DEFAULT_ENV = 'development'

    attr_reader :config, :db_config

    class << self
      attr_accessor :config

      def configure
        self.config ||= Config.instance
        yield config
      end

      def env= env
        @env = env
      end

      def env
        return @end if @env
        return Rails.env if defined? Rails
        DEFAULT_ENV
      end
    end

    def initialize
      @config = build_app_config
    end

    def tasks
      config.fetch(:app, {}).fetch(:generate_tasks, [])
    end

    def create(name:, extension:, output_dir: nil)
      output_dir ||= config_dir
      generated_file = ERBConfig.new(filtered_config, name, extension, config_dir, output_dir)
      generated_file.bindings = bindings
      generated_file.save!
    end

    private

    def build_app_config
      app_config = {
        app_root_dir: app_root,
        app_shared_dir: app_shared_dir,
        app_base_dir: app_base,
        local_config_file: local_config_file,
        secrets_file_path: secrets_file,
        vhost: config_vhost_dirs
      }

      app_config.deep_merge! app_config_defaults
      app_config[:secrets] = get_secret_contents(app_config)
      app_config[:db_config] = build_db_config

      get_local_config app_config
    end

    def build_db_config
      config_file_exists = File.exist? db_config_path
      db_config_file = config_file_exists ? db_config_path : default_db_config_file
      process_config_file(db_config_file)
    end

    def app_config_defaults
      return @app_config_defaults if @app_config_defaults
      app_config_file = File.join(configuration.config_dirname, configuration.config_filename)
      app_defaults = app_defaults_init.dup
      config_properties = process_config_file(app_config_file)
      @app_config_defaults = app_defaults.deep_merge! config_properties
    end

    def process_config_file(config_file)
      config_file_contents = File.read(config_file)
      config_file_contents = ERB.new(config_file_contents).result
      config_file_contents = YAML.safe_load(config_file_contents, [], [], true)
      config_file_contents[Configurinator.env].deep_symbolize_keys!
    rescue Errno::ENOENT
      raise "Missing config file: #{config_file}"
    end

    def config_vhost_dirs
      {
        public_dir: File.join(app_root, 'public'),
        shared_dir: app_shared_dir,
        log_dir: File.join(app_root, 'log'),
        pids_dir: File.join(app_root, 'tmp', 'pids')
      }
    end

    def get_local_config(app_config)
      if local_config_file_exists? app_config
        app_config.deep_merge! process_config_file(app_config[:local_config_file])
      end
      app_config
    end

    def local_config_file_exists?(app_config)
      local_rails_config_file = File.join(configuration.root_path, configuration.local_config_filename)

      File.exist?(app_config[:local_config_file]) ||
        File.exist?(app_config[:local_config_file] = local_rails_config_file)
    end

    def get_secret_contents(app_config)
      secrets_file_contents = {}
      if File.exist? app_config[:secrets_file_path]
        secrets_file_contents = process_config_file app_config[:secrets_file_path]
      end
      secrets_file_contents
    end

    def filtered_config
      @filtered_config ||= config.except(*configuration.app_setup_blocks)
    end

    def use_capistrano?
      app_config_defaults[:app][:use_capistrano]
    end
  end
end
