class Course < ActiveRecord::Base
  belongs_to :message, optional: true
end
