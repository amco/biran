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
You can also set options in `config/app_config.yml` in the `app` block. This list will be loaded last and override anything set in the initializer.


```
Biran.configure do |config|
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
:db_config,
:secrets
:root_path,
:app_env,
:bindings,
:app_setup_blocks,
:files_to_generate
```

TODO: add description on what each one does
## files_to_generate
This config option defines which files you want to be available to generate as part of the config:generate task. Each file listed will get its own task and will be run when `rake config:generate` is run.
The default config will generate `config/vhost.conf` and `config/database.yml`. By default, all files will be generated in the `config` directory. You can override this in the options.
Basic exmple from `config/app_config.yml`:
```
app:
  files_to_generate:
    vhost:
      extension: 'conf'
    database:
      extension: '.yml'
    settings:
      extension: '.yml'
    reports:
      extension: ‘.yml’
      output_dir: ‘/srv/app/current/reports’
```

