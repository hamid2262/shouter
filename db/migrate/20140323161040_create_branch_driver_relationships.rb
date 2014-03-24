class CreateBranchDriverRelationships < ActiveRecord::Migration
  def change
    create_table :branch_driver_relationships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :branch, index: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
