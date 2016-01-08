require 'test_helper'

class AuthenticationServiceTest < ActiveSupport::TestCase

  describe 'tokenize' do
    it 'should return a valid HS256 JWT' do
      claims = { hello: 'there' }
      token = AuthenticationService.tokenize claims
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { alg: 'HS256' })
      assert_equal 'there', decoded_token[0]['hello']
    end

    it 'should have 24 hour expiration date' do
      claims = { hello: 'there' }
      token = AuthenticationService.tokenize claims
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { alg: 'HS256' })
      assert_equal 24.hours.from_now.to_i, decoded_token[0]['exp']
    end
  end

  describe 'decode' do
    it 'should decode a token made with secret' do
      claims = { user_id: 123 }
      token = JWT.encode claims, Rails.application.secrets.secret_key_base, 'HS256'
      decoded_token = AuthenticationService.decode token
      assert_equal 123, decoded_token[:user_id]
    end

    it 'should return nil for invalid token' do
      decoded_token = AuthenticationService.decode 'invalid'
      assert_nil decoded_token
    end

    it 'should return nil for wrong secret' do
      claims = { user_id: 123 }
      token = JWT.encode claims, 'wrong_secret', 'HS256'
      decoded_token = AuthenticationService.decode token
      assert_nil decoded_token
    end
  end

  describe 'decoded token expired?' do
    it 'should not be expired if token just created' do
      token = AuthenticationService.tokenize({ user_id: 123 })
      decoded_token = AuthenticationService.decode token
      assert_not decoded_token.expired?
    end
  end

end
