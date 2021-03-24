class Source < ActiveRecord::Base
  has_many :messages, foreign_key: :source_mmsi, primary_key: :mmsi
  has_many :courses, through: :messages
  has_many :positions, through: :messages
  has_many :mysteries, through: :messages

  scope :recent, -> (offset = 0) {
    where('messages_count > 1').order(:updated_at).offset(offset)
  }
end
