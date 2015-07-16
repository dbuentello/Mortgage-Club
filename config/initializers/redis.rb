if Rails.env.development? || Rails.env.test?
  $redis = Redis.new(:host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT'])
elsif Rails.env.produciton?
  uri = URI.parse(ENV['REDISTOGO_URL'])

  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
