json.array!(@trips) do |trip|
  json.extract! trip, :date, :total_available_seats, :detail, :user_id
  json.url trip_url(trip, format: :json)
end
