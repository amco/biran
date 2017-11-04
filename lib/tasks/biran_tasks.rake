namespace :config do
  config = Biran::Configurinator.new

  desc 'Generate new config files'
  task :generate do
    Rake::Task['config:generate_with_deps'].enhance config.tasks
    Rake::Task['config:generate_with_deps'].invoke
  end

  task :generate_with_deps

  desc 'Generate the vhost config file'
  task :vhost do
    config.create name: :vhost, extension: '.conf'
  end

  desc 'Generate the database.yml file'
  task :database do
    config.create name: :database, extension: '.yml'
  end

  desc 'Generate the settings.yml file'
  task :settings do
    config.create name: :settings, extension: '.yml'
  end
end
