require 'test_helper'

class AttendancesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get attendances_show_url
    assert_response :success
  end

  test "should get edit" do
    get attendances_edit_url
    assert_response :success
  end

end
