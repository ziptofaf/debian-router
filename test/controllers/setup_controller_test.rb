require 'test_helper'

class SetupControllerTest < ActionController::TestCase
  test "should get quicksetup" do
    get :quicksetup
    assert_response :success
  end

  test "should get advanced" do
    get :advanced
    assert_response :success
  end

end
