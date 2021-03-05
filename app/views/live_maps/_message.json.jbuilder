json.positions message[1].map(&:position)
json.course message[1].map(&:course)
json.static message[1].map(&:source).uniq.first
