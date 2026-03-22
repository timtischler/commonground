require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "new renders sign-in page" do
    get login_path
    assert_response :success
    assert_select "form[action*='google_oauth2']"
  end

  test "destroy clears session and redirects" do
    delete logout_path
    assert_redirected_to login_path
  end
end
