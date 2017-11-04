require 'rails'

module Biran
  class Railtie < Rails::Railtie
    railtie_name :biran

    rake_tasks do
      load File.join File.dirname(__FILE__), '../tasks/biran_tasks.rake'
    end
  end
end


