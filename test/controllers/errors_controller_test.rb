require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
  test "should get NotFound," do
    get :NotFound,
    assert_response :success
  end

  test "should get Exception" do
    get :Exception
    assert_response :success
  end

end
