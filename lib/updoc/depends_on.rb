require 'updoc/config'
require 'updoc/consumers'

module Updoc
  module DependsOn
    DependsOnConfig = Struct.new(:feature, :consumers)

    def self.included(base)
      base.include(Updoc::Config) unless base < Updoc::Config
      base.updoc.extend(UpdocClassMethods)
      base.updoc.config[:depends_on] = DependsOnConfig.new(base.to_s.underscore, {})
    end

    module UpdocClassMethods
      def depends_on(name, *service_urn)
        config.depends_on.consumers[name] ||= []
        config.depends_on.consumers[name].concat(service_urn).uniq!
      end
    end
  end
end
