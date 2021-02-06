class Course < ActiveRecord::Base
  belongs_to :message, optional: true

  alias_attribute :course, :course_over_ground
  alias_attribute :speed, :speed_over_ground
end
