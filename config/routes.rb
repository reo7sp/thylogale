Rails.application.routes.draw do
  root to: 'page_folders#index'

  resources :page_folders, except: [:edit, :new] do
    resources :pages, except: [:index, :edit, :new], shallow: true do
      get 'preview', on: :member
      get 'raw', on: :member
    end

    get 'search', on: :member
  end
end
