Rails.application.routes.draw do
  root to: 'calendar#index'
  resources :events
  get '/export/icalendar' => 'events#icalendar', as: 'export_icalendar'
  get '/import/google_calendar' => 'events#gcal', as: 'import_google_calendar'
  post '/get_events' => 'events#get_events'
  post '/events/:id/share' => 'events#share', as: 'share_event'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
