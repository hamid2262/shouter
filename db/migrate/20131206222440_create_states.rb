class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :local_name
      t.belongs_to :country, index: true

      t.timestamps
    end
  end
end
