Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products, only: [:index, :show]

  get "/cart", to: "cart#show", as: :cart
  post "/cart/add/:product_id", to: "cart#add", as: :add_to_cart
  patch "/cart/update/:product_id", to: "cart#update", as: :update_cart
  delete "/cart/remove/:product_id", to: "cart#remove", as: :remove_from_cart

  root to: "products#index"
end