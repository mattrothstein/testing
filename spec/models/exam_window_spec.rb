# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExamWindow, type: :model do
  describe "Associations" do
    it { should have_many(:exam_registrations).without_validating_presence }
    it { should belong_to(:exam).without_validating_presence }
  end

  describe "Validations" do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
  end
end
