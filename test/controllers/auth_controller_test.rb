require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get signup" do
    get :signup
    assert_response :success
  end

  test "should get loginpage" do
    get :loginpage
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get logout" do
    get :logout
    assert_response :success
  end

end
