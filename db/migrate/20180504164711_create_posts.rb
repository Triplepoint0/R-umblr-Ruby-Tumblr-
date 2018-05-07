class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :user_id
      t.string :title
      t.string :post
      t.datetime :created_at
      t.datetime :updated_at
  end
end
end
