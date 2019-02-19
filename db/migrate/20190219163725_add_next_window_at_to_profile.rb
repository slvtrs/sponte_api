class AddNextWindowAtToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :next_window_at, :datetime
  end
end
