class CreateVehicleModelTranslations < ActiveRecord::Migration

  def up
    VehicleModel.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end

  def down
    VehicleModel.drop_translation_table! migrate_data: true
  end

end
