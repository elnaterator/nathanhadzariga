require 'test_helper'

class UserTest < ActiveSupport::TestCase

  let(:user) { User.create! name: 'Bill Billson', email: 'test@test.com' }

  it "should have name and email" do
    user.name.must_equal 'Bill Billson'
    user.email.must_equal 'test@test.com'
  end

end
