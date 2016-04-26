require 'ostruct'

module Updoc
  module Config

    FeatureConfig = Struct.new(:feature_name, :config)

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def updoc
        @updoc ||= FeatureConfig.new(
          Updoc.underscore(self.name),
          OpenStruct.new
        )
      end
    end
  end
end
