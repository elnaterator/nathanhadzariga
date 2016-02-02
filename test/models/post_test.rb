require 'test_helper'

class PostTest < ActiveSupport::TestCase

  describe 'attributes' do

    let(:post) { posts(:one) }

    it 'should have title, body, and author attributes' do
      assert_equal 'First post', post.title
      assert_equal 'This is my first post.', post.body
      assert_equal 1, post.author_id
    end

    it 'should validate presence of title, body and author' do
      assert Post.new(title: 'title', body: 'body', author_id: 123).valid?
      assert_not Post.new(title: '', body: 'body', author_id: 123).valid?
      assert_not Post.new(title: 'title', body: '', author_id: 123).valid?
      assert_not Post.new(title: 'title', body: 'body', author_id: nil).valid?
    end

  end



end
