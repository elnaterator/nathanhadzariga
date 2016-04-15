require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  describe 'routing' do
    it 'should map to index, show, create, update, and destroy' do
      assert_routing({method:'GET',path:'/posts'},{controller:'posts',action:'index'})
      assert_routing({method:'GET',path:'/posts/123'},{controller:'posts',action:'show',id:"123"})
      assert_routing({method:'POST',path:'/posts'},{controller:'posts',action:'create'})
      assert_routing({method:'PATCH',path:'/posts/123'},{controller:'posts',action:'update',id:"123"})
      assert_routing({method:'DELETE',path:'/posts/123'},{controller:'posts',action:'destroy',id:"123"})
    end
  end

  describe 'index' do
    describe 'not logged in' do
      before { get :index }
      it 'should be successful' do
        assert_response 200
      end
      it 'should return all posts' do
        resp = JSON.parse(@response.body)
        assert_equal 3, resp.length
      end
      it 'should return author name in each post' do
        post = JSON.parse(@response.body)[0]
        assert_equal 1, post['author_id']
        assert_equal 'Andy Anderson', post['author_name']
      end
      it 'should return comments for post' do
        post = JSON.parse(@response.body)[0]
        assert_equal 1, post['id']
        comments = post['comments']
        assert_equal 2, comments.length
      end
    end
  end

  describe 'show' do
    describe 'not logged in' do
      before { get :show, {id: 1} }
      it 'should be successful' do
        assert_response 200
      end
      it 'should return post' do
        resp = JSON.parse(@response.body)
        assert_equal 'First post', resp['title']
        assert_equal 'This is my first post.', resp['body']
      end
      it 'should return author name' do
        resp = JSON.parse(@response.body)
        assert_equal 1, resp['author_id']
        assert_equal 'Andy Anderson', resp['author_name']
      end
      it 'should return comments for post' do
        post = JSON.parse(@response.body)
        assert_equal 1, post['id']
        comments = post['comments']
        assert_equal 2, comments.length
      end
    end
  end

  describe 'not logged in' do

    it 'should not allow access to create, update, and destroy' do
      post :create, {title:'Test title',body:'test body.',author_id:123}
      assert_response 401
      patch :update, {id:1,title:'Test title'}
      assert_response 401
      delete :destroy, {id:1}
      assert_response 401
    end

  end

  describe 'logged in as user' do

    token = nil
    before { token = authenticate_as('USER') }

    it 'should not allow access to create, update, and destroy' do
      post :create, {title:'Test title',body:'test body.',author_id:123}
      assert_response 401
      patch :update, {id:1,title:'Test title'}
      assert_response 401
      delete :destroy, {id:1}
      assert_response 401
    end
  end

  describe 'logged in as admin' do

    token = nil
    before { token = authenticate_as('ADMIN') }

    # create

    describe 'create' do
      it 'should create a new post' do
        assert_difference('Post.count') do
          post :create, {title:'Title',body:'Some body.',author_id:1}
        end
      end

      it 'should return the post data in response' do
        post :create, {title:'Title',body:'Some body.',author_id:1}
        assert_response 201
        resp = JSON.parse(@response.body)
        assert_equal 'Title', resp['title']
      end

      it 'should return errors' do
        post :create, {title:nil,body:'Some body.',author_id:1}
        assert_response 422
        resp = JSON.parse(@response.body)
        assert_equal "can't be blank", resp['title'][0]
      end
    end

    # update

    describe 'update' do
      it 'should update a post' do
        patch :update, {id:1,title:'New title'}
        assert_equal 'New title', Post.find(1).title
      end

      it 'should return the post data' do
        patch :update, {id:1,title:'New title'}
        assert_response 200
        resp = JSON.parse(@response.body)
        assert_equal 'New title', resp['title']
        assert_equal 'This is my first post.', resp['body']
      end

      it 'should return errors' do
        patch :update, {id:1,title:nil}
        assert_response 422
        resp = JSON.parse(@response.body)
        assert_equal "can't be blank", resp['title'][0]
      end
    end

    # destroy

    describe 'destroy' do
      it 'should destroy a post' do
        assert_difference('Post.count', -1) do
          delete :destroy, {id:1}
          assert_response 204
        end
      end
    end

  end

end
