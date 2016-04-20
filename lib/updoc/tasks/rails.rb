require 'updoc'

namespace :updoc do
  namespace :rails do
    desc "Create updoc.yml report"
    task :report => :environment do
      puts "Writing report to #{Updoc::Report::RailsReport.report!}"
    end
  end
end
