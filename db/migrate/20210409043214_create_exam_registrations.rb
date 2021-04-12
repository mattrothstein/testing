# frozen_string_literal: true

class CreateExamRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :exam_registrations do |t|
      t.belongs_to :exam_window, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :start_time

      t.timestamps
    end
  end
end
