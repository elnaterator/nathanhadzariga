require 'test_helper'

class PostTest < ActiveSupport::TestCase

  describe 'basic fields' do

    let(:post) { posts(:one) }

    it 'should include title and body' do
      assert_equal 'First post', post.title
      assert_equal 'This is my first post.', post.body
    end

    it 'should validate presence of title and body' do
      assert Post.new(title: 'title', body: 'body', author_id: 123).valid?
      assert_not Post.new(title: '', body: 'body', author_id: 123).valid?
      assert_not Post.new(title: 'title', body: '', author_id: 123).valid?
    end

  end

  describe 'author' do
    let(:user) { users(:one) }

    it 'should be required' do
      assert_not Post.new(title:'title',body:'body').valid?
      assert Post.new(title:'title',body:'body',author:user).valid?
    end

    it 'should allow access to author fields' do
      post = Post.new(title:'title',body:'body',author:user)
      assert_equal 'Andy Anderson', post.author.name
      assert_equal 'andy@test.com', post.author.email
    end

  end



end
