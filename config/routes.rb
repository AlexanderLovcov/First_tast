Rails.application.routes.draw do
  root "articles#index"
  resources :articles do
    member do
      get 'analyze', to: 'articles#count_comments'
    end
    resources :comments, only: [:index, :create, :destroy]
  end

end
