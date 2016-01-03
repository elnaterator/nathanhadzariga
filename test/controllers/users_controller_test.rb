require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one) # andy anderson
  end

  test "should show list of users" do
    get :index
    assert_response :success
    users = JSON.parse(@response.body)
    assert_equal users(:one).name, users[0]['name']
    assert_equal users(:two).name, users[1]['name']
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { name: 'Henry Henderson', email: 'henry@test.com' }
    end
    assert_response :success
    user = JSON.parse(@response.body)
    assert_equal 'Henry Henderson', user['name']
    assert_equal 'henry@test.com', user['email']
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
    user = JSON.parse(@response.body)
    assert_equal 'Andy Anderson', user['name']
    assert_equal 'andy@test.com', user['email']
  end

  test "should update user" do
    patch :update, id: @user, user: { name: 'Andy A Anderson' }
    user = JSON.parse(@response.body)
    assert_equal 'Andy A Anderson', user['name']
    assert_equal 'andy@test.com', user['email']
    @user.reload
    assert_equal 'Andy A Anderson', @user[:name]
    assert_equal 'andy@test.com', @user[:email]
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end
    assert_response :success
  end

  test "should have proper routing" do
    assert_routing({ method: 'get', path: '/users' }, { controller: 'users', action: 'index' })
    assert_routing({ method: 'post', path: '/users' }, { controller: 'users', action: 'create' })
    assert_routing({ method: 'get', path: '/users/123' }, { controller: 'users', action: 'show', id: '123' })
    assert_routing({ method: 'patch', path: '/users/123' }, { controller: 'users', action: 'update', id: '123' })
    assert_routing({ method: 'delete', path: '/users/123' }, { controller: 'users', action: 'destroy', id: '123' })
  end
end
