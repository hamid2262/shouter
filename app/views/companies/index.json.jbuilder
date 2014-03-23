json.array!(@companies) do |company|
  json.extract! company, :name, :tel, :email
  json.url company_url(company, format: :json)
end
