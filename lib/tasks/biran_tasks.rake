namespace :config do
  config = Biran::Configurinator.new

  desc 'Legacy - Generate all new config files'
  task :generate_legacy do
    Rake::Task['config:generate_with_deps'].enhance config.file_tasks
    Rake::Task['config:generate_with_deps'].invoke
  end

  task :generate_with_deps

  desc 'Generate all new config files'
  task :generate do
    error_count = 0
    config.file_tasks.each do |task|
      Rake::Task["config:#{task}"].invoke
    rescue Biran::ConfigSyntaxError => e
      error_count += 1
      puts e.p_warning
      next
    end

    abort 'Errors in creating config files' unless error_count == 0
  end

  config.files_to_generate.each do |file_name, options|
    desc %(Generate the #{file_name}#{options.fetch(:extension, '')} config file)
    task file_name do
      config.create name: file_name, **options
    rescue ArgumentError => e
      e_message = "Missing required argument or bad formatting in config file for #{file_name}"
      e.set_backtrace([])
      raise Biran::ConfigSyntaxError, e_message
    rescue Biran::ConfigSyntaxError => e
      e.set_backtrace([])
      raise Biran::ConfigSyntaxError, e.message
    end
  end

end
