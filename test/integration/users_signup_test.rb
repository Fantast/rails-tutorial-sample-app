require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid form submission should not create a user" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: '',
                              email: 'email_is@invalid',
                              password: 'foo',
                              password_confirmation: 'bar'}

    end

    assert_template 'users/new'
  end

  test "valid form submission should create a user" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {name: 'Example User',
                                           email: 'email_is@valid.edu',
                                           password: 'foobar',
                                           password_confirmation: 'foobar'}

    end

    assert_template 'users/show'
  end
end
