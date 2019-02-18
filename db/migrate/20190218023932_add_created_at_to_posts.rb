class AddCreatedAtToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :created_at, :datetime, null: false
  end
end
