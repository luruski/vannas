ActiveAdmin.register Product do
  permit_params :name, :description, :price, :category_id, :image, :available, :on_sale, :sale_price, tag_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :category
    column :price do |product|
      number_to_currency(product.price)
    end
    column :on_sale
    column :available
    column :tags do |product|
      product.tags.map(&:name).join(", ")
    end
    column :image do |product|
      if product.image.attached?
        image_tag product.image.variant(:thumb), height: 50
      end
    end
    actions
  end

  filter :name
  filter :category
  filter :available
  filter :price
  filter :on_sale
  filter :tags

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :price, min: 0.01
      f.input :category
      f.input :available
      f.input :on_sale
      f.input :sale_price, min: 0
      f.input :tags, as: :check_boxes, collection: Tag.order(:name)
      f.input :image, as: :file, hint: f.object.image.attached? ? image_tag(f.object.image.variant(:thumb), height: 100) : "No image uploaded"
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
      row :on_sale
      row :sale_price do |product|
        number_to_currency(product.sale_price) if product.sale_price
      end
      row :tags do |product|
        product.tags.map(&:name).join(", ")
      end
      row :image do |product|
        if product.image.attached?
          image_tag product.image.variant(:medium)
        end
      end
      row :created_at
    end
  end
end