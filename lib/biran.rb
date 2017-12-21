require 'biran/config_defaults'
require 'biran/config'
require 'biran/erb_config'
require 'biran/configurinator'
require 'biran/railtie' if defined?(Rails)

module Biran

  def self.configure &blk
    Configurinator.configure &blk
  end
end
