class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :status
      t.date :pickup_date
      t.text :notes
      t.decimal :gst_amount
      t.decimal :pst_amount
      t.decimal :hst_amount

      t.timestamps
    end
  end
end
