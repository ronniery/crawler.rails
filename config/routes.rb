Rails.application.routes.draw do
  root 'main#index'
  
  get '/404', to: 'application#not_found'
  match 'quotes/:tag' => 'quotes#show', :via => :get
end
