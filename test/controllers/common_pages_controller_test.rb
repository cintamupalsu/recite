require 'test_helper'

class CommonPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | Hadith Open"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | Hadith Open"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | Hadith Open"
  end
  
  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | Hadith Open"
  end
end
