require "test_helper"

class ChatsScopingTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = User.create!(email: "user1@example.com", name: "User 1", google_uid: "uid1")
    @user2 = User.create!(email: "user2@example.com", name: "User 2", google_uid: "uid2")
  end

  test "user only sees their own chats on index" do
    chat1 = Chat.create!(model: "claude-sonnet-4-6", user: @user1)
    chat2 = Chat.create!(model: "claude-sonnet-4-6", user: @user2)

    sign_in_as(@user1)
    get chats_path
    assert_response :success
    assert_includes response.body, "chat_#{chat1.id}"
    refute_includes response.body, "chat_#{chat2.id}"
  end

  test "creating a chat assigns it to current user" do
    sign_in_as(@user1)
    assert_difference -> { @user1.chats.count }, 1 do
      post chats_path, params: { chat: { prompt: "Hello", model: "claude-sonnet-4-6" } }
    end
  end

  test "user cannot access another user's chat" do
    chat2 = Chat.create!(model: "claude-sonnet-4-6", user: @user2)
    sign_in_as(@user1)
    get chat_path(chat2)
    assert_redirected_to chats_path
  end
end
