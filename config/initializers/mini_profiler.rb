if Rails.env.development? && false
  require 'rack-mini-profiler'

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end

# Rack::MiniProfiler.config.position = 'left'
# Rack::MiniProfiler.config.start_hidden = false