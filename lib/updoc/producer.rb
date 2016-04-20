require 'updoc/config'

module Updoc
  module Producer
    ProducerConfig = Struct.new(:feature_name, :service_type)

    def self.included(base)
      base.include(Updoc::Config) unless base < Updoc::Config
      base.updoc.extend(UpdocClassMethods)
      base.updoc.config[:producer] = ProducerConfig.new(base.updoc.feature_name)
    end

    module UpdocClassMethods
      def produce_as(name: nil, service_type: nil)
        config.producer.feature_name = name if name
        config.producer.service_type = service_type if service_type
      end
    end
  end
end
