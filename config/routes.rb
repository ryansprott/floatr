Rails.application.routes.draw do
  root to: "sources#summary"

  resources :sources do
    resources :positions, only: [:index]
    resources :heatmaps, only: [:index]
    resources :messages, only: [:show]
    resources :statics, only: [:show]
  end
  constraints format: :json do
    resources :source_summaries, only: [:index]
  end
  resources :live_maps, only: [:index]
end
