class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body
      t.integer :author_id
      t.belongs_to :post
      t.timestamps null: false
    end
  end
end
