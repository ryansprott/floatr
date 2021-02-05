class Message < ApplicationRecord
  has_one :course, dependent: :destroy
  has_one :dimension, dependent: :destroy
  has_one :mystery, dependent: :destroy
  has_one :position, dependent: :destroy
end
