# frozen_string_literal: true

Rails.application.routes.draw do
  resources :exam_registrations, only: :create
end
