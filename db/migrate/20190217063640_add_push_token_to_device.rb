class AddPushTokenToDevice < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :push_token, :string
  end
end
