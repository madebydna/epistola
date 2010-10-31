require 'active_record'
require 'active_record/fixtures'

namespace :db do
  desc "Loads default seed data for demo purposes"
  task :load_default  do
    Dir.glob(File.join(Rails.root, "db", "sample" , '*.yml')).each do |fixture_file|
      Fixtures.create_fixtures(File.dirname(file) , File.basename(file, '.*') )
    end
  end
  
end