# frozen_string_literal: true

college = College.create(name: "University of Miami")
exam = college.exams.create(name: "LSAT")
User.create(first_name: "Matt", last_name: "Rothstein", phone_number: "13052221010")

# create 3 one hour long exam windows
[8, 10, 12].each do |x|
  start_time = DateTime.now.beginning_of_day + x.hours
  end_time = start_time + 1.hour
  exam.exam_windows.create(start_time: start_time, end_time: end_time)
end
