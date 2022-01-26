Rails.application.routes.draw do
  root "articles#index"
  resources :articles
  patch '/articles/:id', to: 'articles#scrub', as: 'analyze'


end
