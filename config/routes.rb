Rails.application.routes.draw do
  resources :page_folders, except: [:edit, :new], constraints: {id: /.*/}, path: 'pages' do
    resources :pages, except: [:edit, :inbox], path: 'contents' do
      member do
        get 'preview'
        get 'raw'
      end
    end

    collection do
      get 'search'
    end
  end
end
