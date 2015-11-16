task :stats => "mortgage_club:stats"

namespace :mortgage_club do
  task :stats do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << ["Views", "app/views"]
    ::STATS_DIRECTORIES << ["Services", "app/services"]
    ::STATS_DIRECTORIES << ["Policies", "app/policies"]
    ::STATS_DIRECTORIES << ["Presenters", "app/presenters"]
    ::STATS_DIRECTORIES << ["Forms", "app/forms"]
  end
end