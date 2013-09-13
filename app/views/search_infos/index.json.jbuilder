json.array!(@search_infos) do |search_info|
  json.extract! search_info, 
  json.url search_info_url(search_info, format: :json)
end
