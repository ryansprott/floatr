class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.references :message, foreign_key: true
      t.decimal :course_over_ground
      t.decimal :speed_over_ground
    end
  end
end
