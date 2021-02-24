class Source < ActiveRecord::Base
  has_many :messages, foreign_key: :source_mmsi, primary_key: :mmsi
  has_many :courses, through: :messages
  has_many :positions, through: :messages
  has_many :mysteries, through: :messages
end
