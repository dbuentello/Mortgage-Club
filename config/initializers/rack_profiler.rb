if Rails.env.development? && ENV['OPEN_RACK_PROFILER'] != 'false'
  require 'rack-mini-profiler'

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end