ActiveAdmin.register Product do
  permit_params :name, :description, :price, :category_id, :image, :available

  index do
    selectable_column
    id_column
    column :name
    column :category
    column :price do |product|
      number_to_currency(product.price)
    end
    column :available
    actions
  end

  filter :name
  filter :category
  filter :available
  filter :price

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :price
      f.input :category
      f.input :available
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price do |product|
        number_to_currency(product.price)
      end
      row :category
      row :available
      row :created_at
    end
  end
end