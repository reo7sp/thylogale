Rails.application.routes.draw do
  root to: redirect('/page_folders')

  match '/setup', to: 'first_setups#setup', via: :get
  match '/setup', to: 'first_setups#init', via: [:post, :put, :patch], as: :init

  resources :page_folders, except: [:edit, :new, :create] do
    member do
      post 'subfolders', to: 'page_folders#create'
      get 'search'
    end

    resources :pages, except: [:index, :edit, :new], shallow: true do
      member do
        get 'preview'
        get 'raw'
      end

      resources :page_assets, except: [:index, :edit, :new], shallow: true do
        member do
          get 'raw'
        end
      end
    end
  end
end
