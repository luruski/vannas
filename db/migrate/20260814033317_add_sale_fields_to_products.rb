class AddSaleFieldsToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :on_sale, :boolean, default: false, null: false
    add_column :products, :sale_price, :decimal, precision: 8, scale: 2
  end
end