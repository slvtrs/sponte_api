class AddLastWindowAtToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :last_window_at, :datetime
  end
end
