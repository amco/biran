module Biran
  class ERBConfig
    attr_reader :output_dir, :source_dir, :name, :extension, :config, :template_contents
    attr_accessor :bindings, :output_name, :template_config_index

    DEFAULT_TEMPLATE_CONFIG_INDEX = 1

    def initialize(config, name, extension, source, output_dir, output_name)
      before_process_erb do
        @name       = name
        @extension  = extension
        @config     = config
        @source_dir = source
        @output_dir = output_dir
        @output_name = output_name
      end
    end

    def save!
      File.open(File.join(output_dir, "#{output_name}#{extension}"), 'w') do |f|
        f.print template_contents.result(build_erb_env.call)
      end
    end

    private

    def before_process_erb
      yield
      raise ArgumentError unless process_erb_ready?
      @template_contents = process_erb
    rescue ArgumentError
      e_message = "Settings required to determine template name for #{name} are not configured"
      raise Biran::ConfigSyntaxError, e_message
    end

    def process_erb_ready?
      @name &&
      @extension &&
      @source_dir
    end

    def process_erb
      config_erb_file = File.join(source_dir, "_#{name}#{extension}.erb")
      ERB.new(File.read(config_erb_file), trim_mode: '-')
    rescue Errno::ENOENT
      raise Biran::ConfigSyntaxError, "Missing template file for #{name}: #{config_erb_file}"
    end

    def build_erb_env
      proc do
        @environment = config[:env]
        @app_config  = config
        @config_index =  template_config_index || DEFAULT_TEMPLATE_CONFIG_INDEX

        @bindings.each(&assign_instance_vars) unless @bindings.nil?

        # This pulls these variables into a binding object which is returned
        binding
      end
    end

    def assign_instance_vars
      lambda do |bindable|
        instance_variable_set(:"@#{bindable}", config[bindable.to_sym])
      end
    end
  end
end
