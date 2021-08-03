# encoding: utf-8
require "logstash/outputs/ks3/rotations/size_based_rotation"
require "logstash/outputs/ks3/rotations/time_based_rotation"

module LogStash
  module Outputs
    class Ks3
      class HybridRotation
        def initialize(size_rotate, time_rotate)
          @size_strategy = SizeBasedRotation.new(size_rotate)
          @time_strategy = TimeBasedRotation.new(time_rotate)
        end

        def rotate?(file)
          @size_strategy.rotate?(file) || @time_strategy.rotate?(file)
        end

        def needs_periodic_check?
          true
        end
      end
    end
  end
end