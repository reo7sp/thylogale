Rails.application.routes.draw do
  root to: 'page_folders#index'

  resources :page_folders do
    resources :pages, shallow: true
  end
end
