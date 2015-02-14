class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to  :user
      t.string      :payment_to
      t.integer     :amount
      t.string      :note
      t.integer     :venmo_payment_id
      t.string      :venmo_payment_status

      t.timestamps
    end
  end
end
