class CreateVehicleBrandTranslations < ActiveRecord::Migration

  def up
    VehicleBrand.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end

  def down
    VehicleBrand.drop_translation_table! migrate_data: true
  end

end

