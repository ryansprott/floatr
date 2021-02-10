Rails.application.routes.draw do
  root to: "sources#index"

  resources :sources do
    resources :positions, only: [:index]
    resources :heatmaps, only: [:index]
  end
end
