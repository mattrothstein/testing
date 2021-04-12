# frozen_string_literal: true

class CreateExams < ActiveRecord::Migration[6.0]
  def change
    create_table :exams do |t|
      t.belongs_to :college, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
