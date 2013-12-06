json.array!(@vehicles) do |vehicle|
  json.extract! vehicle, :user_id, :color, :number_plate, :air_condition, :year, :image, :vehicle_model_id
  json.url vehicle_url(vehicle, format: :json)
end
