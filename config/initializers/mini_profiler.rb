if Rails.env.development? && ENV['OPEN_RACK_PROFILER']
  require 'rack-mini-profiler'

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end

# Rack::MiniProfiler.config.position = 'left'
# Rack::MiniProfiler.config.start_hidden = false