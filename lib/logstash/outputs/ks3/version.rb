# encoding: utf-8

module LogStash
  module Outputs
    class Ks3
      class Version
        VERSION = "0.1.2"
        def self.version
          VERSION
        end
      end
    end
  end
end
