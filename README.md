# Biran

That guy that creates the config files for every new proyect.

# Current State

This is a simple proof of concept on the configuration files we use in most of our rails/ruby projects.

This version will look for an `app_config.yml` file in `config` folder in the project root.

# TODO:

- Documentation
- Create config yml generators
- Add option for server config, right now only creates nginx vhost file and mysql database files for rails AR projects.
- More stuff

# Use
In a rails app, simply include the gem in your Gemfile:
```
gem 'biran'
```

In a non-rails app, you will need to do some extra work to make the tasks available to rake. In your Rakefile you will need to manually include things.
Here is a minimal Rakefile for a basic ruby app that includes the biran tasks along with any local tasks in `lib/tasks`
```
require 'bundler/setup'
Bundler.require

biran_gem = Gem::Specification.find_by_name 'biran'
Dir["#{biran_gem.gem_dir}/lib/tasks/*.rake"].each do |file|
  Rake::load_rakefile(file)
end

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

Dir.glob('lib/tasks/*.rake').each {|r| import r}
```

# Configuration

You can set where your config files are, rails end and other stuff in a file like `config/initializers/biran.rb`
You can also set options in `config/app_config.yml` in the `app` block. This list will be loaded last and override anything set in the initializer. All string
input is sanitized to remove special characters that don't play well with file system paths. Any special haracters found are replaced with a '-'.

Config file example:
```
defaults: &defaults
  app: &app_defaults
    base_path: <%= Rails.root %>
    use_capistrano: false
    bindings:
      - db_config
    files_to_generate:
      vhost:
        extension: 'conf'

development:
  <<: *defaults

test:
  <<: *defaults

staging:
  <<: *defaults
  app:
    <<: *app_defaults
    base_path: '/srv/my_app'
    use_capistrano: true

production:
  <<: *defaults
  app:
    <<: *app_defaults
    base_path: '/srv/my_app'
    use_capistrano: true
  vhost:
    <<: *vhost_defaults
    host: 'my_app.example.com'
```

Initializer example:
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
:extra_config_suffix,
:config_dirname,
:base_path,
:shared_dir,
:use_capistrano,
:db_config,
:secrets
:app_env,
:bindings,
:app_setup_blocks,
:files_to_generate
:vhost_public_dirname
```
## Options
### config_filename

**Type: string  
Default: app\_config.yml  
Available in:** environment variable, initializer

Set the name of the file that is used to hold configuration values for the app and any template files. File should be found in the `config` directory of your app.

### local_config_filename
**Type: string  
Default: local\_config.yml  
Available in: environment variable, config_file, initializer**

Sets the name of the file that can be used to override any values in the config file. Used to insert values you don’t want stored in the repo, like passwords.
Uses same format as the main config file. Any value you enter will override the value from the config file.  
For example, assuming default gem configuration and a staging environment, if you want to change the port number that nginx is running the site on, you could use a `config/local_config.yml` with the following contents:
```
defaults: &defaults
  vhost:
    <<: *vhost_defaults
    port: 8080

staging:
  <<: *defaults
```

### db_config_file_name
**Type: string  
Default: db\_config.yml  
Available in: config file, initializer**

Sets the name of the file that holds the default database configuration info used to generate files. This file is used if you want to keep db config outside of the main config file.

### secrets_filename
**Type: string  
Default: secrets  
Available in: config file, initializer**

Generally no need to change, but here in case you want to. Default is `secrets.yml`

### extra_config_suffix
**Type: string  
Default: extras  
Available in: environment variable, config_file, initializer**

Sets the suffix to be applied to an extra config file you may want to load. The suffix is appended to the value of the config_filename. The default value will be `app_config_extras.yml`.
This file gets loaded just before the local config file and can be used to provide additional configuration based stored in a second file. There are times when you may want to organize the
configuration based on sub grouping that the yaml just doesn't allow easily.  
Use cases might include grouping config based on a location, type of host, or even for testing purposes.

### config_dirname
**Type: string  
Default: config  
Available in: initializer**

Generally no need to change, but here in case you want to change the default of where templates and generated config files are stored.

### base_path
**Type: string  
Default: Rails.root in rails apps, ‘./’ in others  
Available in: environment variable, config file, initializer**

Biran assumes you will be using `Rails.root` in dev of course and will use that value unless something else is specified. If using capistrano, you will want to define the base_path not including `current`. Biran will use this path to find the shared dir and the local config dir used to override any values.

### shared_dir
**Type: string  
Default: shared  
Available in: config file, initializer**

Generally not needed, but can be used to override the shared dir value when using capistrano.

### use_capistrano
**Type: string/boolean  
Default: false  
Available in: config file, initializer**

When using Biran with capistrano, Biran will make certain path adjustments for you, including appending the `current` dir to the root path as well as assuming any override files are in the `shared/config` dir in the root path when using default values.


### db_config
**Type: hash  
Default: ‘’  
Available in: config file, initializer**

Set database configuration info. Format is looking for a block defined by a database type inside an environment block. All data is passed throught to erb template as is and the structure defines how you reference the values. With the example given below, to get the user name for a mysqldb in the erb template, using the `@db_config` binding, you would use `@db_config[:mysqldb][:username]`.
Ex:
```
mysqldb:
  default: &default
    adapter: mysql1
    encoding: utf7
    pool: 4
    username: root
    password:
    database: app_db
    host: localhost

development:
  mysqldb:
    <<: *default

test:
  mysqldb:
    <<: *default

staging:
  mysqldb:
    <<: *default
    username: app_user

production:
  mysqldb:
    <<: *default
    username: app_user
```

### secrets
**Type: hash  
Default: ‘’  
Availble in: config file, initializer**

This value can be used to hold values you don’t want stored in repo with purpose of overriding in local config file. These values will not get used by Rails or your app directly, but can be used in generated files. Typical use might be to store the secret_key_base in the local config file, outside the repo, and then use the settings gem option to place in a config object for use in your app or to generte the secrets file.
Ex. in config file:
```
defaults: &defaults
  secrets:
    secret_key_base: 123459876h
```

### app_env
**Type: string  
Default: Rails.env if rails or ‘development’ in non rails  
Availble in: environment, initializer, instance**

Generally not needed to specify unless you are not using rails or do not want to use `Rails.env` for lookups in config blocks.  
You can set the app_env during instance creation by passing an environment string.  
The following example will use the value of one of the built in environment variable found, checked in the following order: BIRAN_APP_ENV, RAILS_ENV, RACK_ENV. If one of the environment variables is not found, the default value will be used.
```
config = Biran::Configurinator.new
```
If you need to specify the environment on the instance directly, you can do the following to create a staging config object independent of the other app_env settings:
```
config = Biran::Configurinator.new(env: ‘staging)
```

### bindings
**Type: array  
Default: db\_config  
Available in: config file, initializer**

Used to setup some shortcuts for use in the erb templates. Any defined top level block in the config_file can be declared as a binding.
Useful to have shorter variables in templates. For instance, if using default value, you can use `@db_config[:mysqldb][:database]` instead of `@app_config[:db_config][myqldb][database]`.
Ex.
With the following config snippet as an example, you can use `@vhost[:host]` instead of `@app_config[:vhost][:host]`
```
defaults: &defaults
  app: &app_defaults
    base_path: <%= Rails.root %>
    use_capistrano: false
    bindings:
      - db_config
      - vhost
    files_to_generate:
      vhost:
        extension: '.conf'
      database:
        extension: '.yml'
  vhost: &vhost_defaults
    host: 'www.example.com'
    port: 80
    ssl_port: 443
    use_ssl: false
```
### app_setup_blocks
**Type: array  
Default: app  
Available in: config file, initializer**

Generally not needed to configure, but available. Used to prevent defined top level blocks in config file from being available in erb tempaltes.

### files_to_generate
**Type: hash  
Default:**  
```
{
  vhost: {extension: '.conf'}
}
```  
**Available in: config file, initializer**

This config option defines which files you want to be available to generate as part of the config:generate task. Each file listed will get its own task and will be run when `rake config:generate` is run.
The default config will generate `config/vhost.conf` only. By default, all files will be generated in the `config` directory. You can override this in the options by setting an `output_dir` and/or an `output_name` to define the location and the name to be added to the extension.  
NOTE: If you use the `output_name` option, the template name is still pulled from the block name. In the example below, for the reports file, the template name would be `config/_reports.yml.erb` and the block will generate a file in `/srv/app/current/reports` named `user_report.yml`.  
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
      output_name: ‘user_report’
```  

In a more advanced example, you can generate multiple files from the same template by setting the `config_index_list` option. If you set this as a list of indexes, then a file will be generated for each index. The index number 
will get passed to the template as an instance variable (`@config_index`) and can be used to look up a specific version of values from the config file. The file that is generated will respect the normal naming, including using the `output_name` option, however, it will append the 
index number to the end of the file name. If the name was going to be special_file, and you add an index list of `[1,2]`, two files will get generated named `special_file-1` and `special_file-2`.  
Advanced example from `config/app:.yml`:
```
app:
  files_to_generate:
    reports:
      extension: '.yml'
      config_index_list:
        - one
        - two
reports:
  default: &reports_default_values
    some_value: 'some_value'
    other_value: 'other_value'
  one:
    <<: *reports_default_values
  two:
    <<: *reports_default_values
    some_value: 'my_value'
```  
Then in your template file you can use the index to get the proper config for each generated file. This allows you to reuse the same template to generate multiple files, each with different content. This is useful for generating service config files, like for sidekiq workers.
The config above would generate two files: `config/reports-one.yml` and `config/reports-two.yml`, using the content from each index block as specified in the following simple template example.
```
<% index = "{@config_index}" -%>
defaults:
  :some_value: <%= @app_config[:reports][index.to_sym][:some_value] %>
  :other_value: <%= @app_config[:reports][index.to_sym][:other_value] %>
```  

### vhost_public_dirname
**Type: string  
Default: 'public'  
Available in: config file, initializer**

Used to change the value of the public web directorname for use in the vhost config. Defined in the app block
```
app:
  vhost_public_dirname: 'web'
```

