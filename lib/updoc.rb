require "updoc/version"
require 'updoc/config'
require 'updoc/consumer'
require 'updoc/consumers'
require 'updoc/depends_on'
require 'updoc/producer'
require 'updoc/report'

module Updoc

  class << self
    attr_accessor :application_name

    def git?
      !`git --version`.nil?
    end

    # Based on ActiveSupport#underscore - https://github.com/rails/rails/blob/861b70e92f4a1fc0e465ffcf2ee62680519c8f6f/activesupport/lib/active_support/inflector/methods.rb#L91-L100
    def underscore(camel_cased_word)
      return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
      word = camel_cased_word.to_s.gsub(/::/, '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end
