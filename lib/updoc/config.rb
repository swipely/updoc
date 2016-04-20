module Updoc
  module Config

    Storage = Struct.new(:feature_name, :config)

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def updoc
        @updoc ||= Storage.new(
          self.to_s.underscore,
          OpenStruct.new
        )
      end
    end
  end
end
