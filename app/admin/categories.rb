ActiveAdmin.register Category do
  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name
    column :description
    column "Products" do |category|
      category.products.count
    end
    actions
  end

  filter :name

  form do |f|
    f.inputs "Category Details" do
      f.input :name
      f.input :description
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
    end
    panel "Products" do
      table_for resource.products do
        column :name
        column :price do |product|
          number_to_currency(product.price)
        end
        column :available
      end
    end
  end
end