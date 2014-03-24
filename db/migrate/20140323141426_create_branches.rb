class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name, limit: 80
      t.string :address
      t.string :email, limit: 80
      t.string :tel, limit: 80
      t.string :mobile, limit: 80
      t.string :city, limit: 80
      t.string :slug
      t.float :blat
      t.float :blng
      t.belongs_to :company, index: true
      t.belongs_to :user, index: true
      t.attachment :cover

      t.timestamps
    end
  end
end
