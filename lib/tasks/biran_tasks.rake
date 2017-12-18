namespace :config do
  config = Biran::Configurinator.new

  desc 'Generate new config files'
  task :generate do
    Rake::Task['config:generate_with_deps'].enhance config.tasks_list
    Rake::Task['config:generate_with_deps'].invoke
  end

  task :generate_with_deps

  config.config_generate_files.each do |file_name, options|
    desc %(Generate the #{file_name}#{options.fetch(:extension, '')} config file)
    task file_name do
      config.create name: file_name, **options
    end
  end

end
