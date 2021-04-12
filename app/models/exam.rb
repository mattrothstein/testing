# frozen_string_literal: true

class Exam < ApplicationRecord
  belongs_to :college
  has_many :exam_windows
end
