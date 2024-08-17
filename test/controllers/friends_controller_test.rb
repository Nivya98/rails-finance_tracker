require "test_helper"

class FriendsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get friends_search_url
    assert_response :success
  end
end
