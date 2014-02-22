class DropCitiesTable < ActiveRecord::Migration
  def up
  	drop_table :cities
  	drop_table :states
  	drop_table :countries
  end

  def down
    create_table :cities do |t|
      t.belongs_to :state, index: true
      t.string :name
      t.string :local_name
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    create_table :countries do |t|
      t.string :name
      t.string :local_name

      t.timestamps
    end

    create_table :states do |t|
      t.string :name
      t.string :local_name
      t.belongs_to :country, index: true

      t.timestamps
    end

  end
end
