json.positions message[1].map(&:lat_lon)
json.source message[1].map(&:source).uniq.first
