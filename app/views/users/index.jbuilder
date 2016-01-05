json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :created_at, :updated_at
end
