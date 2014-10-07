Rails.application.routes.draw do


  post 'garage/update' => 'garage#update', as: :garage_update
  get 'garage/status' => 'garage#status', as: :garage_status
  get 'garage/history' => 'garage#history', as: :garage_history

  root to: 'garage#status'

end
