json.array!(@spacial_events) do |spacial_event|
  json.extract! spacial_event, :title, :image, :permalink, :origin_id, :destination_id, :origin_cycle, :destination_cycle, :start_date, :end_date
  json.url spacial_event_url(spacial_event, format: :json)
end
