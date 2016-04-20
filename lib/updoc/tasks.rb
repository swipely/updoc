require 'updoc'

module Updoc
  module Tasks
      def self.load_rails_tasks
        gem_spec = Gem::Specification.find_by_name('updoc')
        require File.join(gem_spec.gem_dir, 'lib/updoc/tasks/rails')
      end

      def self.load_rack_tasks
        gem_spec = Gem::Specification.find_by_name('updoc')
        require File.join(gem_spec.gem_dir, 'lib/updoc/tasks/rack')
      end
  end
end
