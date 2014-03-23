class CreateTransportationCompanies < ActiveRecord::Migration
  def change
    create_table :transportation_companies do |t|
      t.string :name,  limit: 80
      t.string :tel,   limit: 20
      t.string :email, limit: 40
			t.attachment :image
			t.attachment :cover

      t.timestamps
    end
  end
end
