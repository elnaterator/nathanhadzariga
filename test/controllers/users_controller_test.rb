require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  describe 'index' do
    it 'should return list of users' do
      get :index
      assert_response :success
      users = JSON.parse(@response.body)
      assert_equal users(:one).name, users[0]['name']
      assert_equal users(:two).name, users[1]['name']
    end
  end

  describe 'create' do
    it 'should create user' do
      assert_difference('User.count') do
        post :create, user: { name: 'Henry Henderson', email: 'henry@test.com', password: 'hello123', password_confirmation: 'hello123' }
      end
      assert_response :success
      user = JSON.parse(@response.body)
      assert_equal 'Henry Henderson', user['name']
      assert_equal 'henry@test.com', user['email']
    end
  end

  describe 'show' do
    let(:user) { users(:one) }

    it 'should show user' do
      get :show, id: user
      assert_response :success
      resp = JSON.parse(@response.body)
      assert_equal 'Andy Anderson', resp['name']
      assert_equal 'andy@test.com', resp['email']
    end
  end

  describe 'update' do
    let(:user) { users(:one) }

    it 'should update user' do
      patch :update, id: user, user: { name: 'Andy A Anderson' }
      resp = JSON.parse(@response.body)
      assert_equal 'Andy A Anderson', resp['name']
      assert_equal 'andy@test.com', resp['email']
      user.reload
      assert_equal 'Andy A Anderson', user[:name]
      assert_equal 'andy@test.com', user[:email]
    end
  end

  describe 'destroy' do
    let(:user) { users(:one) }

    it 'should destroy user' do
      assert_difference('User.count', -1) do
        delete :destroy, id: user
      end
      assert_response :success
    end
  end

  describe 'routing' do
    it 'should have proper mapping' do
      assert_routing({ method: 'get', path: '/users' }, { controller: 'users', action: 'index' })
      assert_routing({ method: 'post', path: '/users' }, { controller: 'users', action: 'create' })
      assert_routing({ method: 'get', path: '/users/123' }, { controller: 'users', action: 'show', id: '123' })
      assert_routing({ method: 'patch', path: '/users/123' }, { controller: 'users', action: 'update', id: '123' })
      assert_routing({ method: 'delete', path: '/users/123' }, { controller: 'users', action: 'destroy', id: '123' })
    end
  end
end
