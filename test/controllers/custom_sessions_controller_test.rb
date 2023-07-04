require "test_helper"

class CustomSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get custom_sessions_new_url
    assert_response :success
  end
end
