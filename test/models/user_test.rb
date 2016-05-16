require 'test_helper'

class UserTest < ActiveSupport::TestCase

  let(:user) { User.create! name: 'Bill Billson', email: 'test@test.com', password: 'hello123', password_confirmation: 'hello123' }

  it "should have name field with validation" do
    user.name.must_equal 'Bill Billson'
    user.name = nil
    assert_not user.valid?
    user.name = 'Bill@bill.com'
    assert_not user.valid?
    user.name = 'Billlllllllllllllllllllllllllll' # length = 31
    assert_not user.valid?
  end

  describe 'email' do
    it 'should disallow invalid format' do
      user.email = 'jfkdlsjfdkls'
      assert_not user.valid?
      assert_equal 'is invalid', user.errors[:email][0]
    end
    it 'should disallow missing email' do
      user.email = nil
      assert_not user.valid?
      assert_equal "can't be blank", user.errors[:email][0]
    end
  end

  describe 'password' do

    it "should be required for new user" do
      user2 = User.new(name: 'Henry', email: 'henry@email.com')
      assert_not user2.valid?
      user2.password = 'password'
      assert_not user2.valid?
      user2.password_confirmation = 'password'
      assert user2.valid?
    end

    it "should be at least 8 characters long" do
      user2 = User.new(name: 'Henry', email: 'henry@email.com')
      user2.password = 'passwrd'
      user2.password_confirmation = 'passwrd'
      assert_not user2.valid?
    end

    it "should not be required for existing user" do
      user2 = users(:one)
      assert user2.password.nil?
      assert user2.password_confirmation.nil?
      assert user2.password_digest
      assert user2.valid?
    end

    it "should be updateable" do
      user.password = 'different'
      user.password_confirmation = 'different'
      assert user.save
    end

    it "should be authenticated" do
      assert_not user.authenticate('notright')
      assert user.authenticate('hello123')
    end

  end

  describe 'roles' do

    it 'should defualt to USER' do
      assert_equal 'USER', user.role
    end

    it 'should be settable on creation' do
      user = User.create(name: 'Test', email: 'test@email.com', password: 'pass', password_confirmation: 'pass', role: 'ADMIN')
      assert_equal 'ADMIN', user.role
    end

    it 'should have helper to test if admin' do
      assert_not user.admin?
      user.update(role: 'ADMIN')
      assert user.admin?
    end

  end

end
