Rails.application.routes.draw do
  root to: 'main#index'

  match '/setup', to: 'first_setups#setup', via: :get
  match '/setup', to: 'first_setups#init', via: [:post, :put, :patch], as: :init

  resources :page_folders, except: [:edit, :new] do
    resources :pages, except: [:index, :edit, :new], shallow: true do
      get 'preview', on: :member
      get 'raw', on: :member
    end

    get 'search', on: :member
  end
end
