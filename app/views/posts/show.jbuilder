json.extract! @post, :id, :title, :body, :author_id, :created_at, :updated_at
json.author_name @post.author.name
