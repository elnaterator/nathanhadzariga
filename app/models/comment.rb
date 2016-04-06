class Comment < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :post

  validates_presence_of :body, :author_id, :post_id
  validates_length_of :body, maximum: 250
end
