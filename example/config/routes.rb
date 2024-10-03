Rails.application.routes.draw do
  get "test/slow", to: "test#slow"
  get "test/fast", to: "test#fast"
  get "test/random", to: "test#random"
end
