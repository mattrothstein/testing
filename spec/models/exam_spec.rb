# frozen_string_literal: true

require "rails_helper"

RSpec.describe Exam, type: :model do
  describe "Associations" do
    it { should have_many(:exam_windows).without_validating_presence }
    it { should belong_to(:college).without_validating_presence }
  end
end
