namespace :config do
  config = Biran::Configurinator.new

  desc 'Generate new config files'
  task :generate do
    Rake::Task['config:generate_with_deps'].enhance config.file_tasks
    Rake::Task['config:generate_with_deps'].invoke
  end

  task :generate_with_deps

  config.files_to_generate.each do |file_name, options|
    desc %(Generate the #{file_name}#{options.fetch(:extension, '')} config file)
    task file_name do
      begin
       config.create name: file_name, **options
      rescue ArgumentError => e
        puts 'Missing required argument or bad formatting in config file'
        puts e
      end
    end
  end

end
