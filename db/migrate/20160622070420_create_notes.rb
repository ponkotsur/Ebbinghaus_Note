class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :guid
      t.string :title
      t.text :content
      t.integer :contentLength
      t.date :created
      t.date :updated
      t.string :active
      t.integer :updateSequenceNum
      t.string :notebookGuid
      t.integer :notebook_id

    end
  end
end
