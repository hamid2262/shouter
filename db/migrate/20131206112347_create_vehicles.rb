class CreateVehicles < ActiveRecord::Migration
  def change
    create_table   :vehicles do |t|
      t.belongs_to :user, index: true
      t.belongs_to :vehicle_model, index: true
      t.string     :color
      t.string     :number_plate
      t.boolean    :air_condition
      t.date       :year
      t.string     :image

      t.timestamps
    end
  end
end
