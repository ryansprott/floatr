Rails.application.routes.draw do
  root to: "sources#index"

  resources :sources do
    resources :positions, only: [:index]
    resources :heatmaps, only: [:index]
    resources :messages, only: [:show]
    resources :statics, only: [:show]
  end
  resources :live_maps, only: [:index]
end
