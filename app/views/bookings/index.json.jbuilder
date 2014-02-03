json.array!(@bookings) do |booking|
  json.extract! booking, :passenger_id, :acceptance_status
  json.url booking_url(booking, format: :json)
end
