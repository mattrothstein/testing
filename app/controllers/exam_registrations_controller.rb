# frozen_string_literal: true

class ExamRegistrationsController < ApplicationController
  def create
    user              = User.find_or_create_by!(user_params)
    college           = College.find(params[:college_id])
    exam              = college.exams.find(params[:exam_id])
    exam_registration = user.exam_registrations.new(exam: exam, start_time: params[:start_time])

    if exam_registration.save
      render json: exam_registration.to_json(include: { exam_window: { include: :exam } }), status: :ok
    else
      render json: { error: { exam_registration: exam_registration.errors } }, status: 400
    end
  end

  private
    def user_params
      params.permit(:first_name, :last_name, :phone_number)
    end
end
