# frozen_string_literal: true

require "rails_helper"

RSpec.describe College, type: :model do
  describe "Associations" do
    it { should have_many(:exams).without_validating_presence }
  end
end
