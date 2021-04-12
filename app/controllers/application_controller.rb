# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|
    message = "Couldn't find #{exception.model} with 'id'=#{exception.id}"
    Rails.logger.error("Invalid Request - #{message}")

    render json: { error: message }, status: 400
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    Rails.logger.error("Invalid Request - #{exception.message}")
    record        = exception.record
    error_key     = record.class.to_s.underscore

    render json: { error: { error_key => record.errors } }, status: 400
  end
end
