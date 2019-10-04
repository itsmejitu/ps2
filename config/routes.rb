Rails.application.routes.draw do
  root 'home#index'
  get 'ps1/divide'
  get 'ps1/parse'
  get 'ps2/sql'
  get 'ps2/transcript'
  get 'ps2/input'
  post 'ps2/quotations'
  get 'ps2/quotations'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
