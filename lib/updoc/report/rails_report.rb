module Updoc
  module Report
    class RailsReport
      include Updoc::Report

      def self.report!(rails_app = ::Rails.application)
        new(rails_app).report!
      end

      def initialize(rails_app)
        @rails_app = rails_app
        rails_app.eager_load!
      end

      def report!
        report = base_report.merge(
          consumes: map_updoc_consumers,
          produces: map_producers_from_rails
        )

        report[:name] ||= rails_app.class.parent_name

        write_updoc_report(File.expand_path(File.join(rails_app.root, 'updoc.yml')), report)
      end

      def map_producers_from_rails
        if Object.const_defined?('Grape::API')
          map_grape_endpoints(
            rails_app.routes.routes.select do |r|
              r.app.class <= Class && r.app < Grape::API
            end.map { |rails_route| GrapeApp.new(rails_route.app, rails_route.path.spec.to_s) }
          )
        end
      end

      private

      attr_reader :rails_app
    end
  end
end
