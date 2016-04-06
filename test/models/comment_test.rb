require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  describe 'field accessors' do

    let(:comment) { comments(:one) }

    it 'should include body, author_id, and post_id' do
      assert_equal 'Comment one', comment.body
      assert_equal 1, comment.author_id
      assert_equal 1, comment.post_id
    end

    it 'should be associated to post' do
      assert_equal comment.post.title, 'First post'
    end

    it 'should be associated to user through author' do
      assert_equal comment.author.name, 'Andy Anderson'
    end

  end

  describe 'validations' do

    it 'should require body, author_id, and post_id' do
      comment = Comment.new(body: 'body', author_id: 1, post_id: 1)
      assert comment.valid?
      comment.body = nil
      assert_not comment.valid?
      comment.body = 'body'
      comment.author_id = nil
      assert_not comment.valid?
      comment.author_id = 1
      comment.post_id = nil
      assert_not comment.valid?
    end

    it 'should validate max length of 250 characters' do
      comment = Comment.new(body: '', author_id: 1, post_id: 1)
      len250str = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
      comment.body = len250str
      assert comment.valid?
      comment.body = len250str + '0'
      assert_not comment.valid?
    end

  end

end
