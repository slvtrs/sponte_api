class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :installation_id
      t.references :profile_id, foreign_key: true

      t.timestamps
    end
  end
end
