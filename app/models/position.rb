class Position < ApplicationRecord
  belongs_to :message, optional: true
end
