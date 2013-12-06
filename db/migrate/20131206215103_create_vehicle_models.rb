class CreateVehicleModels < ActiveRecord::Migration
  def change
    create_table :vehicle_models do |t|
      t.belongs_to :vehicle_brand, index: true
      t.string :name
      t.integer :seats_number
      t.string :default_image
      t.string :up_view_image

      t.timestamps
    end
  end
end
