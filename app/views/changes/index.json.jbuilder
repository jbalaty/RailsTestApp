json.array!(@changes) do |change|
  json.extract! change, :type, :subtype, :data
  json.url change_url(change, format: :json)
end
