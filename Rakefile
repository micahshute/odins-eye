# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks


namespace :db do
    desc "Truncate all tables"
    task :truncate => :environment do
      conn = ActiveRecord::Base.connection
      tables = conn.execute("show tables").map { |r| r[0] }
      tables.delete "schema_migrations"
      tables.each { |t| conn.execute("TRUNCATE #{t}") }
    end

    desc "Drop all tables, re-create and migrate"
    task :phoenix do
        Rake::Task["db:drop"].invoke
        Rake::Task["db:create"].invoke
        Rake::Task["db:migrate"].invoke
    end
  end