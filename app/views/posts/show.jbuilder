json.extract! @post, :id, :title, :body, :author_id, :created_at, :updated_at
json.author_name @post.author.name
json.comments json.array(@post.comments) do |comment|
  json.extract! comment, :id, :body, :author_id
  json.author_name comment.author.name
end
