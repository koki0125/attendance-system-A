require 'test_helper'

class AttendanceControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get attendance_show_url
    assert_response :success
  end

  test "should get edit" do
    get attendance_edit_url
    assert_response :success
  end

end
