json.array!(@requests) do |request|
  json.extract! request, :title, :url
  json.url request_url(request, format: :json)
end
