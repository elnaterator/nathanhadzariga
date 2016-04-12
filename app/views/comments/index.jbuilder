json.array!(@comments) do |comment|
  json.extract! comment, :id, :post_id, :body, :author_id, :created_at, :updated_at
  json.author_name comment.author.name
end
