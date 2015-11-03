require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get register" do
    get :register
    assert_response :success
  end

  test "should get sign_in" do
    get :sign_in
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
