#$redis = Redis::Namespace.new("DynamicTree", :redis => Redis.new)
uri = URI.parse(ENV["REDIS_URL"])
$redis = Redis::Namespace.new(
            url: ENV["REDIS_URL"],
          )
