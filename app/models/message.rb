class Message < ApplicationRecord
  has_one :course
  has_one :dimension
  has_one :mystery
  has_one :position
end
