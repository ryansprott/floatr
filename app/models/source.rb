class Source < ActiveRecord::Base
  has_many :messages, foreign_key: :source_mmsi, primary_key: :mmsi
end
