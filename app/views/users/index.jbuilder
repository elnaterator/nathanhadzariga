json.array!(@users) do |user|
  json.extract! user, :id, :name, :email
  json.url user_url(user)
end
