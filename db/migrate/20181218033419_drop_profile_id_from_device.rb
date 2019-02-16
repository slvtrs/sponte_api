class DropProfileIdFromDevice < ActiveRecord::Migration[5.2]
  def change
    remove_column :devices, :profile_id_id
    add_reference :devices, :profile, foreign_key: true
  end
end
