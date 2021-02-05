class Dimension < ApplicationRecord
  belongs_to :message, optional: true
end
