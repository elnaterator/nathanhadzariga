require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  
  test "name and email are required fields" do
    account = Account.new
    assert_not account.save, "Saved empty name and email"
    account.email = "test.email@test.com"
    assert_not account.save, "Saved empty name"
    account.name = "Example name"
    account.email = ""
    assert_not account.save, "Saved blank email"
    account.email = "test@email.com"
    assert account.save
  end
  
  test "name should not be too long" do
    account = valid_account
    account.name = "a" * 51
    assert_not account.valid?, "Allowed a name too long"
  end
  
  test "email should not be too long" do
    account = valid_account
    account.email = "a" * 91 + "@email.com" # 101 total length
    assert_not account.valid?, "Allowed an email too long"
  end
  
  test "email should be valid format" do
    account = valid_account
    account.email = "invalid"
    assert_not account.valid?, "Allowed invalid email format"
  end
  
  test "name should be valid format" do
    account = valid_account
    account.name = "hello*"
    assert_not account.valid?, "Allowed invalid name format"
  end
  
  def valid_account
    account = Account.new
    account.name = "Henry"
    account.email = "test@email.com"
    account
  end
  
end
