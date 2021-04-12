# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|
    message = "Couldn't find #{exception.model} with 'id'=#{exception.id}"
    render json: { error: message }, status: 400
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    record = exception.record
    render json: { error: { record.class => record.errors } }, status: 400
  end
end
