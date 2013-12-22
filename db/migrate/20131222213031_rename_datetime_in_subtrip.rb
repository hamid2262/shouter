class RenameDatetimeInSubtrip < ActiveRecord::Migration
  def self.up
    rename_column :subtrips, :datetime, :date_time
  end

  def self.down
    rename_column :subtrips, :date_time, :datetime
  end
end
