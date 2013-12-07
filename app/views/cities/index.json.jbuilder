json.array!(@cities) do |city|
  json.extract! city, :name, :state_id, :latitude, :longitude
  json.url city_url(city, format: :json)
end
