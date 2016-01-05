require 'test_helper'

class UserTest < ActiveSupport::TestCase

  let(:user) { User.create! name: 'Bill Billson', email: 'test@test.com' }

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

end
