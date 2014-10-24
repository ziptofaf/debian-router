json.array!(@users) do |user|
  json.extract! user, :id, :username, :level
  json.url user_url(user, format: :json)
end
