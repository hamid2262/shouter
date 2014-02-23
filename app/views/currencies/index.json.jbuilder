json.array!(@currencies) do |currency|
  json.extract! currency, :name
  json.url currency_url(currency, format: :json)
end
