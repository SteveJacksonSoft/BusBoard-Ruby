Rails.application.routes.draw do
  get 'bus_board/index'
  get 'bus_board/bus_times', to: 'bus_board#bus_times'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
