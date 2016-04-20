require 'updoc'

namespace :updoc do
  namespace :rack do
    desc "Create updoc.yml report"
    task :report do
      puts "Writing report to #{Updoc::Report::RackReport.report!}"
    end
  end
end
