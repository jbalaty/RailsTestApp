json.array!(@ad_infos) do |ad_info|
  json.extract! ad_info, :externid, :urlNormalized
  json.url ad_info_url(ad_info, format: :json)
end
