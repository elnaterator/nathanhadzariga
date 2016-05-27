require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  describe 'routing' do
    it 'should have proper mapping' do
      assert_routing({ method: 'get', path: '/users' }, { controller: 'users', action: 'index' })
      assert_routing({ method: 'post', path: '/users' }, { controller: 'users', action: 'create' })
      assert_routing({ method: 'get', path: '/users/123' }, { controller: 'users', action: 'show', id: '123' })
      assert_routing({ method: 'patch', path: '/users/123' }, { controller: 'users', action: 'update', id: '123' })
      assert_routing({ method: 'delete', path: '/users/123' }, { controller: 'users', action: 'destroy', id: '123' })
      assert_routing({ method: 'post', path: '/users/login' }, { controller: 'users', action: 'login' })
      assert_routing({ method: 'post', path: '/users/signup' }, { controller: 'users', action: 'signup'})
      assert_routing({ method: 'post', path: '/users/refresh' }, { controller: 'users', action: 'refresh'})
    end
  end

  describe '#refresh' do
    describe 'not logged in' do
      it 'should be unauthorized' do
        post :refresh
        assert_response 401
      end
    end
    describe 'logged in' do
      token = nil
      before { token = authenticate_as('USER') }
      it 'should refresh token' do
        post :refresh
        assert_response 200
        return_token = @response.headers['access_token']
        assert_not_nil return_token
      end
    end
  end

  #
  # Not logged in
  #

  describe 'with no token' do

    it 'should reject access to index, show, create, update, and destroy' do
      get :index
      assert_response 401
      get :show, { id: 1 }
      assert_response 401
      post :create, { name: 'Bill', email: 'bill@bill.com', password: 'password', password_confirmation: 'password' }
      assert_response 401
      patch :update, { id: 1, name: 'Bill' }
      assert_response 401
      delete :destroy, { id: 1 }
      assert_response 401
    end

    describe 'login' do
      let(:user) { users(:one) }

      it 'should reject invalid credentials' do
        post :login, { email: 'andy@test.com', password: 'notright'}
        assert_equal 401, @response.status
      end

      it 'should grant an access token for valid credentials' do
        post :login, { email: 'andy@test.com', password: 'password' }
        assert_equal 200, @response.status
        access_token = @response.headers['access_token']
        assert_not_nil access_token
        decoded_token = JWT.decode(access_token, nil, false)
        # contains user id
        assert_equal 1, decoded_token[0]['user_id']
        # expires after 24 hours
        exp_tm = decoded_token[0]['exp']
        expected_exp_tm = Time.now.to_i + Figaro.env.session_timeout_seconds.to_i
        assert_equal expected_exp_tm, exp_tm
        # uses correct algorithm
        assert_equal 'HS256', decoded_token[1]['alg']
      end

      it 'should return user' do
        post :login, { email: 'andy@test.com', password: 'password' }
        assert_equal 200, @response.status
        # validate user data is returned
        data = JSON.parse(@response.body)
        assert_equal 'andy@test.com', data['email']
      end

      describe 'signup' do
        let(:user) { users(:one) }

        it 'should return errors for request with invalid input' do
          post :signup, { email: 'blah', name: 'Billy', password: 'password', password_confirmation: 'password'}
          assert_equal 422, @response.status
          data = JSON.parse(@response.body)
          assert_equal 'is invalid', data['email'][0]
        end

        it 'should create user' do
          assert_difference('User.count') do
            post :signup, { email: 'test@email.com', name: 'Billy', password: 'password', password_confirmation: 'password'}
          end
        end

        it 'should grant an access token on successful signup' do
          post :signup, { email: 'bill@bill.com', name: 'Bill', password: 'password', password_confirmation: 'password'}
          assert_equal 201, @response.status
          access_token = @response.headers['access_token']
          assert_not_nil access_token
          decoded_token = JWT.decode(access_token, nil, false)
          # contains user id
          assert_not_nil decoded_token[0]['user_id']
          # expires after 24 hours
          exp_tm = decoded_token[0]['exp']
          expected_exp_tm = Time.now.to_i + Figaro.env.session_timeout_seconds.to_i
          assert_equal expected_exp_tm, exp_tm
          # uses correct algorithm
          assert_equal 'HS256', decoded_token[1]['alg']
        end

        it 'should not allow user to specify role' do
          post :signup, { role: 'ADMIN', email: 'test@test.com', name: 'Bill', password: 'password', password_confirmation: 'password'}
          assert_response 201
          u = User.find_by(email: 'test@test.com')
          assert_equal 'USER', u.role
        end
      end
    end

  end

  #
  # Logged in as a normal user
  #

  describe 'with token, role user (non admin)' do

    token = nil
    before { token = authenticate_as('USER') }

    it 'should not allow access to index or create' do
      get :index
      assert_response 401
      post :create, { name: 'Bill', email: 'bill@bill.com', password: 'password', password_confirmation: 'password' }
      assert_response 401
    end

    it 'should only allow access to show, update, and destroy for self' do
      get(:show, { id: 1 }) # different user
      assert_response 401
      get(:show, { id: 2 }) # self
      assert_response 200
      patch(:update, { id: 1, name: 'Bill' }) # different user
      assert_response 401
      patch(:update, { id: 2, name: 'Bill' }) # self
      assert_response 200
      delete(:destroy, {id: 1}) # different user
      assert_response 401
      delete(:destroy, {id: 2}) # self
      assert_response 204
    end

    it 'should not let user update role (admin or user)' do
      patch(:update, { id: 2, name: 'Bill', role: 'ADMIN' })
      assert_response 200
      assert_equal 'USER', User.find(2).role
    end

  end

  #
  # Logged in as administrator
  #

  describe 'with token, role admin' do

    token = nil
    before { token = authenticate_as('ADMIN') }

    describe 'index' do

      it 'should return list of users' do
        get :index
        assert_response :success
        users = JSON.parse(@response.body)
        assert_equal users(:one).name, users[0]['name']
        assert_equal users(:two).name, users[1]['name']
      end

      it 'should only allow an admin to access' do
        user = users(:one)
        user.update(role: 'ADMIN')
      end
    end

    describe 'create' do
      it 'should create user (including role)' do
        assert_difference('User.count') do
          post(
            :create,
            { role: 'ADMIN', name: 'Henry Henderson', email: 'henry@test.com', password: 'hello123', password_confirmation: 'hello123' }
          )
        end
        assert_response :success
        user = JSON.parse(@response.body)
        assert_equal 'Henry Henderson', user['name']
        assert_equal 'henry@test.com', user['email']
        assert_equal 'ADMIN', user['role']
      end
    end

    describe 'show' do
      let(:user) { users(:one) }

      it 'should show user' do
        get(:show, { id: user })
        assert_response :success
        resp = JSON.parse(@response.body)
        assert_equal 'Andy Anderson', resp['name']
        assert_equal 'andy@test.com', resp['email']
      end
    end

    describe 'update' do
      let(:user) { users(:one) }

      it 'should update user' do
        patch(:update, { id: user, name: 'Andy A Anderson' })
        resp = JSON.parse(@response.body)
        assert_equal 'Andy A Anderson', resp['name']
        assert_equal 'andy@test.com', resp['email']
        user.reload
        assert_equal 'Andy A Anderson', user[:name]
        assert_equal 'andy@test.com', user[:email]
      end

      it 'should be able to update user role' do
        assert_equal 'USER', User.find(2).role
        patch(:update, { id: 2, role: 'ADMIN' })
        assert_response 200
        assert_equal 'ADMIN', User.find(2).role
      end
    end

    describe 'destroy' do
      let(:user) { users(:one) }

      it 'should destroy user' do
        assert_difference('User.count', -1) do
          delete(:destroy, {id: user})
        end
        assert_response :success
      end
    end
  end

end
