require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid form submission" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: '',
                              email: 'email_is@invalid',
                              password: 'foo',
                              password_confirmation: 'bar'}

    end

    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors input[type=email]'
    assert_select 'div.field_with_errors input[type=password]'
  end

  test "valid form submission" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {name: 'Example User',
                                           email: 'email_is@valid.edu',
                                           password: 'foobar',
                                           password_confirmation: 'foobar'}

    end

    assert_template 'users/show'

    assert_not flash.empty?
    assert_select 'div.alert-success'

    assert is_logged_in?
  end
end
