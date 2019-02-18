class AddDefaultsAndInvertToProfile < ActiveRecord::Migration[5.2]
  def change
    change_column :profiles, :window_start_at, :string, default: '8'
    change_column :profiles, :window_end_at, :string, default: '20'
    add_column :profiles, :invert_window, :boolean, default: false
  end
end
