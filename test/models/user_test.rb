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

  it "should have email field with validation" do
    user.email.must_equal 'test@test.com'
    user.email = nil
    assert_not user.valid?
    user.email = 'invalid'
    assert_not user.valid?
  end

  it "should validate password for new user" do
    user2 = User.new(name: 'Henry', email: 'henry@email.com')
    assert_not user2.valid?
    user2.password = 'password'
    assert_not user2.valid?
    user2.password_confirmation = 'password'
    assert user2.valid?
  end

  it "should not validate password or password_confirm if user already persisted with password_digest" do
    user2 = users(:one)
    assert user2.password.nil?
    assert user2.password_confirmation.nil?
    assert user2.password_digest
    assert user2.valid?
  end

  it "should allow user to change password" do
    user.password = 'another'
    user.password_confirmation = 'another'
    assert user.save
  end

  it "should authenticate users password" do
    assert_not user.authenticate('notright')
    assert user.authenticate('hello123')
  end

end
