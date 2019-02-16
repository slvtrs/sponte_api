class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string :bio
      t.string :window_start_at
      t.string :window_end_at

      t.timestamps
    end
  end
end
