# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ExamRegistrations", type: :request do
  describe "POST /exam_registrations" do
    context "with valid params" do
      let!(:college) { College.create(name: "The College") }
      let!(:exam)    { Exam.create(name: "LSAT", college: college) }

      let!(:first_exam_window) do
        ExamWindow.create(
          exam:       exam,
          start_time: DateTime.now.beginning_of_day + 8.hours,
          end_time:   DateTime.now.beginning_of_day + 10.hours
        )
      end

      let!(:second_exam_window) do
        ExamWindow.create(
          exam:       exam,
          start_time: DateTime.now.beginning_of_day + 12.hours,
          end_time:   DateTime.now.beginning_of_day + 14.hours
        )
      end

      let!(:user) do
        User.create(
          first_name:   "Tester",
          last_name:    "Mc Tester",
          phone_number: "13052221010"
        )
      end

      let(:params) do
        {
          first_name: "Tester",
          last_name: "Mc Tester",
          phone_number: "1-305-222-1010",
          college_id: college.id,
          exam_id: exam.id,
          start_time: (first_exam_window.start_time + 1.hour).to_s
        }
      end

      context "when user already exists" do
        it "finds the user, registers for the exam and returns 200 status code" do
          expect(User.count).to eq(1)
          expect(ExamRegistration.count).to eq(0)

          post exam_registrations_path, params: params

          expect(User.count).to eq(1)
          expect(response).to have_http_status(200)
        end
      end

      context "when user does not exist" do
        it "creates the user, registers for the exam and returns a 200 status code" do
          params[:last_name] = "Smith"

          expect(User.count).to eq(1)
          expect(ExamRegistration.count).to eq(0)

          post exam_registrations_path, params: params

          expect(User.count).to eq(2)
          expect(ExamRegistration.count).to eq(1)
          expect(response).to have_http_status(200)
        end
      end

      context "a college with the given college_id is not found" do
        it "returns a 400 status code and error message" do
          params[:college_id] = 100

          post exam_registrations_path, params: params

          expect(response).to have_http_status(400)
          expect(response.body).to eq({ error: "Couldn't find College with 'id'=100" }.to_json)
        end
      end

      context "an exam with the given exam_id is not found or does not belong to the college" do
        it "returns a 400 status code and error message" do
          params[:exam_id] = 100

          post exam_registrations_path, params: params

          expect(response).to have_http_status(400)
          expect(response.body).to eq({ error: "Couldn't find Exam with 'id'=100" }.to_json)
        end
      end

      context "a user fails to be found or created, or failed to get associated with the exam" do
        it "returns a 400 status code and error message" do
          params[:first_name]   = ""
          params[:last_name]    = ""
          params[:phone_number] = ""

          post exam_registrations_path, params: params

          expect(response).to have_http_status(400)
          expected_json_body = {
            error: {
              "User" => {
                phone_number: ["is invalid"],
                first_name:   ["can't be blank"],
                last_name:    ["can't be blank"]
              }
            }
          }.to_json
          expect(response.body).to eq(expected_json_body)
        end
      end

      context "a requested start_time does not fall with in an exam's time window " do
        it "returns a 400 status code and error message" do
          params[:start_time] = (first_exam_window.start_time + 2.days).to_s
          post exam_registrations_path, params: params

          expect(response).to have_http_status(400)
          expected_json_body = {
            error: {
              exam_registration: {
                exam_window: [
                    "There is no exam available for the requested time"
                ]
              }
            }
          }.to_json
          expect(response.body).to eq(expected_json_body)
        end
      end

      context "a requested does not include a start_time " do
        it "returns a 400 status code and error message" do
          params[:start_time] = nil
          post exam_registrations_path, params: params

          expect(response).to have_http_status(400)
          expected_json_body = {
            error: {
              exam_registration: {
                exam_window: [
                    "There is no exam available for the requested time"
                ],
                start_time: [
                  "Start time is required to register for exam"
                ]
              }
            }
          }.to_json
          expect(response.body).to eq(expected_json_body)
        end
      end
    end
  end
end
