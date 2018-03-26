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
    end

    def env
      return @env if @env
      @env = app_env
    end

    def initialize
      @config = build_app_config
    end

    def file_tasks
      files_to_generate.keys
    end

    def debug_stuff
      puts "app env2 is: #{app_env}"
      puts "instance @env is #{@env}"
      puts "env from method is #{env}"
      puts "rack env is #{ENV['RACK_ENV']}"
    end

    def files_to_generate
      @files_to_generate ||= config.fetch(:app, {})
        .fetch(:files_to_generate, configuration.files_to_generate)
        .tap { |files_list| files_list.each(&sanitize_config_files(files_list)) }
    end

    def create(name:, extension:, output_dir: nil)
      output_dir ||= config_dir
      debug_stuff
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
        env: env,
        local_config_file: local_config_file,
        secrets_file_path: secrets_file,
        vhost: config_vhost_dirs
      }

      app_config.deep_merge! app_config_defaults
      app_config[:secrets] = get_secret_contents(app_config)
      app_config[:db_config] = build_db_config

      app_config.deep_merge! local_config_file_contents
    end

    def build_db_config
      default_db_config = base_db_config
      return default_db_config unless File.exist? db_config_override_file
      default_db_config.deep_merge! process_config_file(db_config_override_file)
    end

    def base_db_config
      return @base_db_config if @base_db_config
      return @base_db_config = {} unless File.exists? default_db_config_file
      @base_db_config ||= process_config_file(default_db_config_file)
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
      config_file_contents[env].deep_symbolize_keys!
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

    def local_config_file_contents
      return @local_config_contents if @local_config_contents
      return @local_config_conents = {} unless File.exists? local_config_file
      @local_config_contents = process_config_file(local_config_file)
    end

    def get_secret_contents(app_config)
      secrets_file_contents = {}
      if File.exist? app_config[:secrets_file_path]
        secrets_file_contents = process_config_file app_config[:secrets_file_path]
      end
      secrets_file_contents
    end

    def sanitize_config_files files_list
      lambda do |file, _|
        files_list[file] ||=  {extension: ''}
        ext = files_list[file].fetch(:extension, '').strip
        ext.prepend('.') unless ext.start_with?('.') || ext.empty?
        files_list[file][:extension] = ext
      end
    end

    def filtered_config
      @filtered_config ||= config.except(*configuration.app_setup_blocks)
    end

    def use_capistrano?
      app_config_defaults[:app][:use_capistrano]
    end
  end
end
