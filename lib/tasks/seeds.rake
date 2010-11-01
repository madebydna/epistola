require 'active_record'
require 'active_record/fixtures'

namespace :db do
  desc "Loads default seed data for demo purposes"
  task :load_default => :environment do
    Dir.glob(File.join(Rails.root, "db", "sample" , '*.yml')).each do |fixture_file|
      Fixtures.create_fixtures(File.dirname(fixture_file) , File.basename(fixture_file, '.*') )
    end
  end
  
  desc "Migrate schema to version 0 and back up again. WARNING: Destroys all data in tables!!"
  task :remigrate => :environment do
    # Drop all tables
    ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }

    # Migrate upward
    Rake::Task["db:migrate"].invoke
  end
  
end