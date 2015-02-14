class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :username
      t.string  :email
      t.string  :venmo_access_token
      t.string  :venmo_user_id

      t.timestamps
    end
  end
end
