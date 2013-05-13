module Datamappify
  class Logger
    # A meta method to help record whether an action has been performed
    #
    # @param args [any]
    #   optional args for logging/tracking purpose
    #
    # @return [TrueClass]
    def self.performed(*args)
      true
    end
  end
end
