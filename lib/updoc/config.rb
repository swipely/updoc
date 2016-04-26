module Updoc
  module Config

    FeatureConfig = Struct.new(:feature_name, :config)

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def updoc
        @updoc ||= FeatureConfig.new(
          self.to_s.underscore,
          OpenStruct.new
        )
      end
    end
  end
end
