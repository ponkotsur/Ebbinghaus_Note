class CreateNotebooks < ActiveRecord::Migration
  def change
    create_table :notebooks do |t|
      t.string :title
      t.integer :guid

      t.timestamps null: false
    end
  end
end
