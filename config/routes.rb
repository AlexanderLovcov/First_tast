Rails.application.routes.draw do
  root "articles#index"
  resources :articles do
    member do
      get 'analyze', to: 'articles#count_comments'
      get 'get_comments', to: "comments#create"
    end
    resources :comments, only: [:index]
    #get 'get_comments', to: "comments#create"
  end

end
