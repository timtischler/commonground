require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user with all fields" do
    user = User.new(
      email: "test@example.com",
      name: "Test User",
      google_uid: "123456789",
      avatar_url: "https://example.com/avatar.jpg"
    )
    assert user.valid?
  end

  test "invalid without email" do
    user = User.new(name: "Test", google_uid: "123")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "invalid without google_uid" do
    user = User.new(email: "test@example.com", name: "Test")
    assert_not user.valid?
    assert_includes user.errors[:google_uid], "can't be blank"
  end

  test "email must be unique" do
    User.create!(email: "test@example.com", name: "First", google_uid: "111")
    user = User.new(email: "test@example.com", name: "Second", google_uid: "222")
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "google_uid must be unique" do
    User.create!(email: "one@example.com", name: "First", google_uid: "111")
    user = User.new(email: "two@example.com", name: "Second", google_uid: "111")
    assert_not user.valid?
    assert_includes user.errors[:google_uid], "has already been taken"
  end

  test "user has many chats" do
    assert_respond_to User.new, :chats
  end
end
