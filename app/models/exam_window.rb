# frozen_string_literal: true

class ExamWindow < ApplicationRecord
  belongs_to :exam
  has_many :exam_registrations

  validates_presence_of :start_time, :end_time
end
