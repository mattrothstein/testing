# frozen_string_literal: true

class ExamRegistration < ApplicationRecord
  belongs_to :exam_window
  belongs_to :user

  attr_accessor :exam

  validates :start_time, presence: { message: :required }

  before_validation :set_exam_window

  def set_exam_window
    return unless start_time.present?

    # search for the first available window and set it as the exam window for this registration
    table  = ExamWindow.arel_table
    window = ExamWindow.where(
      table[:exam_id].eq(exam.id).and(table[:start_time].lteq(start_time)).and(table[:end_time].gteq(start_time))
    ).first

    self.exam_window = window
  end
end
