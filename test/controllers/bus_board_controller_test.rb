require "test_helper"

class BusBoardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bus_board_index_url
    assert_response :success
  end

  test "should get bus_times" do
    get bus_board_bus_times_url
    assert_response :success
  end
end
