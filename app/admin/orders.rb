ActiveAdmin.register Order do
  permit_params :status, :pickup_date, :notes

  index do
    selectable_column
    id_column
    column :user do |order|
      order.user&.email
    end
    column :status
    column :pickup_date
    column "Total" do |order|
      number_to_currency(order.grand_total)
    end
    column :created_at
    actions
  end

  filter :status
  filter :created_at

  show do
    attributes_table do
      row :id
      row :user do |order|
        order.user&.email
      end
      row :status
      row :pickup_date
      row :notes
      row :gst_amount do |order|
        number_to_currency(order.gst_amount)
      end
      row :pst_amount do |order|
        number_to_currency(order.pst_amount)
      end
      row :hst_amount do |order|
        number_to_currency(order.hst_amount)
      end
      row "Grand Total" do |order|
        number_to_currency(order.grand_total)
      end
    end

    panel "Order Items" do
      table_for resource.order_items do
        column :product do |item|
          item.product.name
        end
        column :quantity
        column :price_at_purchase do |item|
          number_to_currency(item.price_at_purchase)
        end
        column "Subtotal" do |item|
          number_to_currency(item.price_at_purchase * item.quantity)
        end
      end
    end
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :status, as: :select, collection: ["pending", "paid", "shipped"]
      f.input :pickup_date
      f.input :notes
    end
    f.actions
  end
end