namespace :config do
  config = Biran::Configurinator.new

  desc 'Generate new config files'
  task :generate do
    Rake::Task['config:generate_with_deps'].enhance config.tasks
    Rake::Task['config:generate_with_deps'].invoke
  end

  task :generate_with_deps

  config.config_tasks.each do |task_name, options|
    desc %(Generate the #{task_name}#{options.fetch(:extension, '')} config file)
    task task_name do
      config.create name: task_name, **options
    end
  end

end
