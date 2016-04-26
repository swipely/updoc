require 'updoc/consumers'
require 'updoc/config'

module Updoc
  module Consumer
    RegisterError = Class.new(StandardError)
    ConsumerConfig = Struct.new(:consumer_name, :services)

    def self.included(base)
      base.include(Updoc::Config) unless base < Updoc::Config
      base.updoc.extend(UpdocClassMethods)
      base.updoc.config[:consumer] = ConsumerConfig.new(nil, [])
    end

    module UpdocClassMethods

      def register_consumer(name: , service_type:, definition_uri:)
        config.consumer.consumer_name = name if name
        Updoc::Consumers.register_consumer(name, service_type, definition_uri)
      end

      def register_consumer_service(*service_urns)
        if config.consumer.consumer_name.nil?
          raise RegisterError.new('Must register_consumer before registering a service')
        end

        Updoc::Consumers.register_consumer_services(config.consumer.consumer_name, service_urns)
        config.consumer.services += service_urns
      end
    end
  end
end
