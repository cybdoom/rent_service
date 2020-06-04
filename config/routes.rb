Rails.application.routes.draw do

  get 'info', to: 'info#show'
  get 'test_data', to: "tests#data"

end
