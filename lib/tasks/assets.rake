# lib/tasks/assets.rake
# The webpack task must run before assets:environment task.
# Otherwise Sprockets cannot find the files that webpack produces.
Rake::Task['assets:precompile']
  .clear_prerequisites
  .enhance(['assets:compile_environment'])

Rake::Task['assets:clean'].enhance do
  Rake::Task['db:migrate'].invoke
end

namespace :assets do
  # In this task, set prerequisites for the assets:precompile task
  task :compile_environment => :webpack do
    Rake::Task['assets:environment'].invoke
  end

  desc 'Compile assets with webpack'
  task :webpack do
    sh 'cd client && $(npm bin)/webpack --config webpack.rails.config.js'
  end

  task :clobber do
    rm_rf "#{Rails.root}/app/assets/javascripts/bundle_PublicApp.js"
    rm_rf "#{Rails.root}/app/assets/javascripts/bundle_ClientApp.js"
    rm_rf "#{Rails.root}/app/assets/javascripts/bundle_AdminApp.js"
    rm_rf "#{Rails.root}/app/assets/javascripts/bundle_LoanMemberApp.js"
  end
end
