json.array!(@transportation_companies) do |transportation_company|
  json.extract! transportation_company, :name, :tel, :email
  json.url transportation_company_url(transportation_company, format: :json)
end
