# frozen_string_literal: true

class User < ApplicationRecord
  has_many :exam_registrations

  validates :phone_number, phone: true
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :phone_number, scope: [:first_name, :last_name]

  before_validation :sanitize_phone_number

  def sanitize_phone_number
    self.phone_number = Phonelib.parse(phone_number).sanitized
  end

  def self.find_or_create_by!(user_params)
    user_params[:phone_number] = Phonelib.parse(user_params[:phone_number]).sanitized
    super(user_params)
  end
end
