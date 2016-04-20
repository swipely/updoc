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
  end
end
