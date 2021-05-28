Rails.application.routes.draw do
  root to: "source_summaries#index"

  resources :sources do
    resources :positions, only: [:index]
    resources :heatmaps, only: [:index]
    resources :messages, only: [:show]
    resources :statics, only: [:show]
  end
  resources :source_summaries, only: [:index]
  resources :live_maps, only: [:index]
end
