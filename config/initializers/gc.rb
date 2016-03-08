if Rails.env.staging?
  GC::Profiler.enable
end
