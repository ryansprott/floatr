json.lat message.position&.latitude
json.lon message.position&.longitude
json.course message.course&.course_over_ground&.to_f
json.speed message.course&.speed_over_ground&.to_f
json.distance message.position&.miles_away
json.created_at message&.created_at
