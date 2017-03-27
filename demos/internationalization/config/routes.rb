Rails.application.routes.draw do
  get '/' => redirect('/en/')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope "/:locale" do
    root to: 'home#index'
    devise_for :users
    get ':move' => 'home#play', constraints: { id: /(rock|paper|scissors)/ }
  end
end