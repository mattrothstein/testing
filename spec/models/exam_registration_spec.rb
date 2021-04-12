# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExamRegistration, type: :model do
  let(:college) { College.create(name: "The College") }
  let(:exam) { Exam.create(name: "LSAT", college: college) }

  let(:exam_window) do
    ExamWindow.create(
      exam:       exam,
      start_time: DateTime.now.beginning_of_day + 8.hours,
      end_time:   DateTime.now.beginning_of_day + 10.hours
    )
  end

  let(:user) do
    User.create(
      first_name:   "Testy",
      last_name:    "Mc Tester",
      phone_number: "13052221010"
    )
  end

  describe "Associations" do
    it { should belong_to(:user).without_validating_presence }
    it { should belong_to(:exam_window).without_validating_presence }
  end

  describe "Validations" do
    context "exam_window_for_requested_start_time validation message" do
      it "validates the start time" do
        subject = described_class.new(user: user, exam: exam, start_time: nil)
        expect(subject.valid?).to eq(false)
        expect(subject.errors[:start_time]).to eq(
          ["Start time is required to register for exam"]
        )
      end

      it "validates the existence of an exam_window" do
        start_time_outside_of_window = exam_window.start_time + 4.hours
        subject = described_class.new(user: user, exam: exam, start_time: start_time_outside_of_window)
        expect(subject.valid?).to eq(false)
        expect(subject.errors[:exam_window]).to eq(
          ["There is no exam available for the requested time"]
        )
      end
    end
  end

  describe "#set_exam_window" do
    it "sets the first exam_window for the requested start_time" do
      start_time_within_window = exam_window.start_time + 1.hour
      subject = described_class.create(user: user, exam: exam, start_time: start_time_within_window)
      expect(subject.valid?).to eq(true)
      expect(subject.exam_window).to eq(exam_window)
    end
  end
end
