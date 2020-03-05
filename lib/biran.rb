require 'yaml'
require 'erb'
require 'active_support/core_ext/hash'
require 'biran/config_defaults'
require 'biran/config'
require 'biran/erb_config'
require 'biran/configurinator'
require 'biran/exceptions'
require 'biran/railtie' if defined?(Rails)

module Biran
  def self.configure &blk
    Configurinator.configure &blk
  end

  def self.config
    Configurinator.config
  end
end
