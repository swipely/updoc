module Updoc
  module Report
    class Rack
      include Updoc::Report

      def self.report!
        new.report!
      end

      def initialize
        @rack_app = ::Rack::Server.new(config: 'config.ru').app # loads all the deps
      end

      def report!
        fail 'Updoc.application_name must be defined' unless Updoc.application_name

        report = base_report.merge(
          consumes: map_updoc_consumers,
          produces: map_producers_from_rack
        )

        write_updoc_report(File.expand_path('updoc.yml'), report)
      end

      def map_producers_from_rack
        producers = {}
        middleware = rack_app
        while middleware
          if Object.const_defined?('Grape::API') && middleware.class < Grape::API
            prefix = middleware.class.prefix
            producers.merge!(
              map_grape_endpoints([GrapeApp.new(middleware.class, prefix)])
            )
          end

          middleware = middleware.instance_variable_get('@app')
        end

        producers
      end

      private

      attr_reader :rack_app
    end
  end
end
