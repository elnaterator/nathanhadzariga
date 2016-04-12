require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  describe 'routing' do
    it 'should be child elements of posts' do
      assert_routing({method:'GET',path:'/posts/1/comments'},{controller:'comments',action:'index',post_id:"1"})
      assert_routing({method:'GET',path:'/posts/1/comments/2'},{controller:'comments',action:'show',post_id:"1",id:"2"})
      assert_routing({method:'POST',path:'/posts/1/comments'},{controller:'comments',action:'create',post_id:"1"})
      assert_routing({method:'PATCH',path:'/posts/1/comments/2'},{controller:'comments',action:'update',post_id:"1",id:"2"})
      assert_routing({method:'DELETE',path:'/posts/1/comments/2'},{controller:'comments',action:'destroy',post_id:"1",id:"2"})
    end
  end

  describe 'index' do
    before do
      get :index, {post_id: 1}
    end
    it 'should be publicly accessible' do
      assert_response 200
    end
    it 'should return comments for post' do
      resp = JSON.parse(@response.body)
      assert_equal 2, resp.length
      assert_equal 'Comment one', resp[0]['body']
      assert_equal 'Comment two', resp[1]['body']
    end
  end

  describe 'show' do
    it 'should be publicly accessible' do
      get :show, {post_id: 1, id: 2}
      assert_response 200
    end
    it 'should not return comment if not associated to post' do
      get :show, {post_id: 1, id: 3}
      assert_response 404
    end
  end

  let(:author) {User.find(1)}

  describe 'create' do
    it 'should not be allowed if not logged in' do
      post :create, {post_id: 1, body: 'My comment', author_id: author.id}
      assert_response 401
    end
    describe 'while logged in' do
      before { authenticate_as 'USER' }
      it 'should successfully create new comment' do
        assert_difference('Comment.count') do
          post :create, {post_id: 1, body: 'My comment', author_id: author.id}
          assert_response 201
        end
      end
    end
  end

  describe 'update' do
    it 'should not be allowed if not logged in' do
      patch :update, {post_id: 1, id: 1, body: 'Updated comment', author_id: author.id}
      assert_response 401
    end
    describe 'while logged in' do
      before { authenticate_as 1 }
      it 'should successfully update comments that belong to user' do
        comment = Comment.find_by(author_id: 1)
        patch :update, {post_id: comment.post.id, id: comment.id, body: 'Updated comment', author_id: comment.author.id}
        assert_response 200
        comment = Comment.find(1)
        assert_equal 'Updated comment', comment.body
      end
      it 'should not allow updating another users comment' do
        comment = Comment.find_by(author_id: 2)
        patch :update, {post_id: comment.post.id, id: comment.id, body: 'Updated comment', author_id: comment.author.id}
        assert_response 401
      end
    end
  end

  describe 'destroy' do
    it 'should not be allowed if not logged in' do
      delete :destroy, {post_id: 1, id: 1}
      assert_response 401
    end
    describe 'while logged in' do
      before { authenticate_as 1 }
      it 'should successfully delete comment by current user' do
        assert_difference('Comment.count', -1) do
          comment = Comment.find_by(author_id: 1)
          delete :destroy, {post_id: comment.post.id, id: comment.id}
          assert_response 204
        end
      end
      it 'should not allow deleting comment by another user' do
        comment = Comment.find_by(author_id: 2)
        delete :destroy, {post_id: comment.post.id, id: comment.id}
        assert_response 401
      end
    end
  end

end
