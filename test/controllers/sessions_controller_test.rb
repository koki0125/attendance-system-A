require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get log_in" do
    get sessions_log_in_url
    assert_response :success
  end

end
