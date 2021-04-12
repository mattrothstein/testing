# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      first_name: "Tester",
      last_name: "Mc Testy",
      phone_number: "1-305-222-1010",
    )
  end

  describe "Associations" do
    it { should have_many(:exam_registrations).without_validating_presence }
  end

  describe "Validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:phone_number).with_message("is invalid") }

    it "validates the legitimacy of the phone_number" do
      expect(subject.valid?).to eq(true)
      subject.phone_number = "1234"
      expect(subject.valid?).to eq(false)
      expect(subject.errors.full_messages).to eq(["Phone number is invalid"])
    end
  end

  describe "#sanitize_phone_number" do
    it "saves the sanitized phone number" do
      expect(subject.phone_number).to eq("1-305-222-1010")
      subject.save
      expect(subject.phone_number).to eq("13052221010")
    end
  end

  describe ".find_or_create_by!" do
    context "when phone number is the same but has different format" do
      it "finds the user" do
        subject.save
        expect do
          described_class.find_or_create_by!(
            first_name: "Tester",
            last_name:  "Mc Testy",
            phone_number: "1 (305) 222 1010"
          )
        end.not_to change { User.count }
      end
    end

    context "when phone number is different" do
      it "creates a new user" do
        subject.save
        expect do
          described_class.find_or_create_by!(
            first_name: "Tester",
            last_name:  "Mc Testy",
            phone_number: "1 (305) 222 4040"
          )
        end.to change { User.count }.by(1)
      end
    end
  end
end
