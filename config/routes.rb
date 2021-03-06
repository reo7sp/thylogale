Rails.application.routes.draw do
  root to: redirect('/page_folders')

  match '/setup', to: 'first_setups#setup', via: :get
  match '/setup', to: 'first_setups#init', via: [:post, :put, :patch], as: :init

  resources :page_folders, except: [:edit, :new, :create] do
    member do
      post 'subfolders', to: 'page_folders#create'
    end

    resources :pages, except: [:index, :edit, :new], shallow: true do
      member do
        get 'preview'
        get 'raw'
        post 'publish'
      end

      resources :page_assets, except: [:index, :edit, :new], shallow: true do
      end
    end
  end

  post '/pages/publish_all', to: 'pages#publish_all'
  get '/pages/:id/preview/*asset_path', to: 'pages#preview_asset'

  get '/page_assets/:page_id/:id', to: 'page_assets#show'

  get '/page_search', to: 'page_search#index'
  get '/page_search/:id', to: 'page_search#show'
end
