json.array!(@watched_resources) do |watched_resource|
  json.extract! watched_resource, :type, :lastCheckAt, :urlNormalized, :usage
  json.url watched_resource_url(watched_resource, format: :json)
end
