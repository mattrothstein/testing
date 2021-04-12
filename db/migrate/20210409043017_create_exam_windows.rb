# frozen_string_literal: true

class CreateExamWindows < ActiveRecord::Migration[6.0]
  def change
    create_table :exam_windows do |t|
      t.belongs_to :exam, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
