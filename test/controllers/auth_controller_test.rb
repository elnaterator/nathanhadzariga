require 'test_helper'

class AuthControllerTest < ActionController::TestCase

  describe 'Auth#login' do

    let(:user) { users(:one) } # andy@test.com / password / 1

    it 'should return user' do
      post :login, user: { email: 'andy@test.com', password: 'password' }
      assert_equal 200, @response.status
      # validate user data is returned
      data = JSON.parse(@response.body)
      assert_equal user.id, data['id']
      assert_equal user.name, data['name']
      assert_equal user.email, data['email']
    end

    it 'should reject invalid login with 401' do
      post :login, user: { email: 'andy@test.com', password: 'notright'}
      assert_equal 401, @response.status
      # and empty response (no user data returned)
      assert JSON.parse(@response.body).empty?
    end

    it 'should include token' do
      post :login, user: { email: 'andy@test.com', password: 'password' }
      assert_equal 200, @response.status
      assert_not_nil @response.headers['Token']
      decodedToken = JWT.decode(@response.headers['Token'], nil, false)
      assert_equal 1, decodedToken[0]['user_id']
      assert_equal 'HS256', decodedToken[1]['alg']
    end

  end

end
