Rails.application.routes.draw do
  root to: redirect('/page_folders')

  match '/setup', to: 'first_setups#setup', via: :get
  match '/setup', to: 'first_setups#init', via: [:post, :put, :patch], as: :init

  resources :page_folders, except: [:edit, :new, :create] do
    resources :pages, except: [:index, :edit, :new], shallow: true do
      resources :assets

      member do
        get 'preview'
        get 'raw'
      end
    end

    member do
      get 'search'
    end
  end
  match '/page_folders/:id', to: 'page_folders#create', via: :post, as: :create
end
