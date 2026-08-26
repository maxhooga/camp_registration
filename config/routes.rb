Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "camps#index"

  resources :camps do
    resources :reservations, only: %i[new create]
  end

  resources :reservations, only: %i[index show edit update destroy]
end
