module Biran
  class ERBConfig
    attr_reader :output_dir, :source_dir, :name, :extension, :config
    attr_accessor :bindings

    def initialize(config, name, extension, source, output)
      @name       = name
      @extension  = extension
      @config     = config
      @source_dir = source
      @output_dir = output
    end

    def save!
      File.open(File.join(output_dir, "#{name}#{extension}"), 'w') do |f|
        f.print process_erb.result(build_erb_env.call)
      end
    end

    private

    def process_erb
      config_erb_file = File.join(source_dir, "_#{name}#{extension}.erb")
      ERB.new(File.read(config_erb_file), nil, '-')
    end

    def build_erb_env
      proc do
        @environment = Configurinator.env
        @app_config  = config

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
