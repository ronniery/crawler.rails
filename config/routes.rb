Rails.application.routes.draw do
  root 'main#index'
  
  get '/404', to: 'application#not_found'

  # Match the home directory '/' with the path crate that remains on the same controller
  match '/create' => 'main#create', :via => :post
  match 'quotes/:tag' => 'quotes#show', :via => :get
end
