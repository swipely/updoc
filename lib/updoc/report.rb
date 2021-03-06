require 'updoc'

module Updoc
  module Report
    SORT = [:name, :definition_uri, :consumes, :produces, :updoc_version]

    GrapeApp = Struct.new(:app, :path_prefix)

    def base_report
      {
        name: Updoc.application_name,
        updoc_version: Updoc::VERSION
      }.tap do |report|
        if Updoc.git?
          git_uri = `git config --get remote.origin.url`.strip
          report[:definition_uri] = "git:#{git_uri}/updoc.yml"
        end
      end
    end

    def map_grape_endpoints(grape_apps)
      updoc_supported_routes = grape_apps.flat_map do |grape_app|
        app_feature = grape_app.app.updoc.feature_name if grape_app.app < Updoc::Config

        grape_app.app.endpoints.flat_map do |endpoint|
          endpoint.routes.map do |r|
            detail = {
              description: r.route_description,
              method: r.route_method.downcase,
              path: r.route_path,
              feature: app_feature
            }

            # XXX: Having to manually adding the path prefix may have changed
            # from older Grape versions
            #detail[:path] = File.join(*[grape_app.path_prefix.to_s, detail[:path]].compact) if grape_app.path_prefix

            if endpoint.options[:app]
              detail[:feature] = endpoint.options[:app].updoc.feature_name if endpoint.options[:app] < Updoc::Producer
              detail[:content_types] = endpoint.options[:app].content_types
            end

            detail if detail[:feature]
          end
        end
      end.compact.sort_by { |r| [r[:feature], r[:method], r[:path]] }

      updoc_supported_routes.group_by { |r| r[:feature] }.each_with_object({}) do |(feature, routes), memo|
        memo[feature] = {
          service_type: 'REST',
          services: routes.each_with_object({}) do |route, memo|
            memo["rest:#{route[:method]}:#{route[:path]}"] = route.slice(:description, :content_types)
          end
        }
      end
    end

    def map_updoc_consumers
      dependents = ObjectSpace.each_object(::Class).select { |x| x < Updoc::DependsOn }
      dependents.each_with_object({}) do |dependent, memo|
        consumers = {}

        depends_on = dependent.updoc.config.depends_on
        depends_on.consumers.each do |name, services|
          raise "Referenced consumer #{name} has not be defined" unless Updoc::Consumers[name]

          consumers[name] = {
            service_type: Updoc::Consumers[name].service_type,
            definition_uri: Updoc::Consumers[name].definition_uri,
            services: services
          }
        end

        memo[dependent.updoc.feature_name] = consumers
      end
    end

    def write_updoc_report(file_path, report)
      report = (SORT | report.keys).each_with_object({}) do |key, hash|
        hash[key] = report[key]
      end

      report.delete_if { |_, v| v.nil? || v.empty? }

      IO.write(file_path, report.to_yaml)

      file_path
    end
  end
end

require 'updoc/report/rack_report'
require 'updoc/report/rails_report'
