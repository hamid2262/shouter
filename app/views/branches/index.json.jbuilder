json.array!(@branches) do |branch|
  json.extract! branch, :name, :address, :email, :tel, :city, :blat, :blng, :company_id
  json.url branch_url(branch, format: :json)
end
