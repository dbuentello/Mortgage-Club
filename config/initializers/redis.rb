if Rails.env.produciton?
  uri = URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  REDIS = Redis.new(:host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT'])
end
