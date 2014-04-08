class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :contact, index: true
      t.text :body
      t.boolean :hide4sender, default: false
      t.boolean :hide4receiver, default: false

      t.timestamps
    end
  end
end
