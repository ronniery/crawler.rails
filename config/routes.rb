Rails.application.routes.draw do
  root 'main#index'
  
  # Match the home directory '/' with the path crate that remains on the same controller
  match '/create' => 'main#create', :via => :post
  match 'quotes' => 'quotes#show', :via => :get
  match 'quotes/:tag' => 'quotes#show', :via => :get
  match 'quotes/:tag/:mode' => 'quotes#viewer', :via => :get
end
