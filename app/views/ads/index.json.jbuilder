json.array!(@ads) do |ad|
  json.extract! ad, :title, :description, :id, :price, :url
  json.url ad_url(ad, format: :json)
end
