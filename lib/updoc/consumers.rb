require 'updoc/consumer'

module Updoc
  class Consumers

    Definition = Struct.new(:name, :service_type, :definition_uri, :services)

    class << self
      extend Forwardable

      def_delegators :consumers, *Hash.new.public_methods(false)

      def consumers
        @consumers ||= {}
      end

      def register_consumer(name, service_type, definition_uri)
        consumers[name] ||= Definition.new(name, service_type, definition_uri, [])
      end

      def register_consumer_services(name, service_urns)
        fail "Must register consumer #{name} before adding services #{service_urns}" unless consumers[name]
        consumers[name].services.concat(service_urns).uniq!
      end
    end
  end
end
