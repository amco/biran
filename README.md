# Biran

That guy that creates the config files for every new proyect.

# Current State

This is a simple proof of concept on the configuration files we use in most of our rails/ruby projects.

This version will look for an `app_config.yml` file on `config` folder in the project root.

# TODO:

- Documentation
- Create config yml generators
- Add option for server config, right now only creates nginx vhost file and mysql database files for rails AR projects.
- More stuff


# Configuration

You can set where your config files are, rails end and other stuff in a file like `config/initializers/biran.rb`


```
Biran.Configurinator.configure do |config|
  config.app_env = Rails.env
end
```

the list of things you can configure are:

```
:config_filename,
:local_config_filename,
:db_config_file_name,
:secrets_filename,
:config_dirname,
:root_path,
:shared_dir,
:use_capistrano,
:tasks,
:db_config,
:secrets
:root_path,
:app_env
```

TODO: add description on what each one does

