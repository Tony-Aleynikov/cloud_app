class CreateHdds < ActiveRecord::Migration[6.1]
  def change
    create_table :hdds do |t|
      t.string :hdd_type
      t.integer :size
      t.belongs_to :vm

      t.timestamps
    end
  end
end
