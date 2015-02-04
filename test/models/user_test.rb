require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
        name: "Example User",
        email: "example@domain.com",
        password: "foobar",
        password_confirmation: "foobar"
    )
  end

  test "new user is valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = '    '
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    email_postfix = "@example.com"
    email_prefix_len = 256 - email_postfix.length

    @user.email = "a" * email_prefix_len + email_postfix
    assert_not @user.valid?
  end

  test "email validation should accept VALID addresses" do
    valid_emails = %w[
      correct@sdf.by
      correct_email.address@sdf.edu
      THE_US-ER@foo.bar.org
      first.last@foo.jp
      uncle+bob@tdd.org
    ]

    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "email validation should NOT accept INVALID addresses" do
    invalid_emails = %w[
      incorrect_email
      user_at_foo.com
      incorrect_email@
      incorrect_email@sdf.
      incorrect_email/@sdf.com
      incorrect_email:@sdf.com
      first.last@foo,jp
      foo@bar..com
    ]

    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

end
