module Biran
  class ConfigSyntaxError < ::StandardError
    def initialize(msg=nil)
      @msg = msg || 'Missing required argument or bad formatting in config file'
      set_backtrace []
    end

    def to_s
      @msg
    end

    def p_warning
      "Warning: #{@msg}"
    end
  end
end
