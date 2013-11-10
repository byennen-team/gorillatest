json.array!(@features) do |feature|
  json.extract! feature, 
  json.url feature_url(feature, format: :json)
end
