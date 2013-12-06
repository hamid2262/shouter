json.array!(@vehicle_models) do |vehicle_model|
  json.extract! vehicle_model, :name, :seats_number, :default_image, :vehicle_brand_id, :up_view_image
  json.url vehicle_model_url(vehicle_model, format: :json)
end
