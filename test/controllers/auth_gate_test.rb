require "test_helper"

class AuthGateTest < ActionDispatch::IntegrationTest
  test "unauthenticated user is redirected to login" do
    get chats_path
    assert_redirected_to login_path
  end

  test "authenticated user can access chats" do
    user = User.create!(email: "test@example.com", name: "Test", google_uid: "123")
    sign_in_as(user)
    get chats_path
    assert_response :success
  end
end
