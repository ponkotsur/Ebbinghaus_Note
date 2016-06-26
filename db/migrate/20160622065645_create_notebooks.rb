class CreateNotebooks < ActiveRecord::Migration
  def change
    create_table :notebooks do |t|
      t.string :guid
      t.string :title
      t.string :published

    end
  end
end
