class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name
      t.boolean :private, default: true
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
