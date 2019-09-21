Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get  ':tree_id',                 to: 'nodes#index'
  get  ':tree_id/parent/:id',      to: 'nodes#parents'
  get  ':tree_id/child/:id',       to: 'nodes#children'
end
