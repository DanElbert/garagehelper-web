Rails.application.routes.draw do


  scope path: 'garage', controller: 'garage', as: 'garage' do
    get 'status'
    get 'history'
    get 'summary'
    post 'push_door_opener'

    scope path: 'helper' do
      post 'update'
      get 'keepalive'
    end
  end

  post 'garage/update' => 'garage#update'

  root to: 'garage#status'

end