require 'test_helper'

class UserTest < ActiveSupport::TestCase
 def setup
   @user = User.new(name: "Tester for User", email: "dodolipret@pretdodoli.com",
   password: "dodolipret", password_confirmation: "dodolipret")
 end
 
 test "should be valid" do
   assert @user.valid?
 end
 
 test "name should be present" do
   @user.name = ""
   assert_not @user.valid?
 end
 
 test "email shoud be present" do
   @user.email = ""
   assert_not @user.valid?
 end
 
 test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
 end
  
 test "email shoud not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
 end
  
 test "email validation should accept valid addresses" do
    valid_addresses = %w[yeahman@mansworld.com YIPPIE@blamblam.COM A_E_I_O-U@nyam.bar.org fasola@sido.jp hobbes+calvin@complete.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid? "{valid_address.inspect} should be valid"
    end
 end
 
 test "email address should be unique" do
   duplicate_user = @user.dup
   duplicate_user.email = @user.email.upcase
   @user.save
   assert_not duplicate_user.valid?
 end
 
 test "password should have a minimum length" do
   @user.password = @user.password_confirmation = "q" * 5
   assert_not @user.valid?
 end
 
 test "authenticated? should return false for a user with nil digest" do
   assert_not @user.authenticated?(:remember, '')
 end
 
 test "associated microposts should be destroyed" do
   @user.save
   @user.microposts.create!(content: "Lorem ipsum dolor")
   assert_difference 'Micropost.count', -1 do
     @user.destroy
   end
 end
 
 test "should follow and unfollow a user" do
   holil = users(:holil)
   samsul = users(:samsul)
   assert_not holil.following?(samsul)
   holil.follow(samsul)
   assert holil.following?(samsul)
   assert samsul.followers.include?(holil)
   holil.unfollow(samsul)
   assert_not holil.following?(samsul)
 end
 
 test "feed should have the right posts" do
   holil = users(:holil)
   falaq = users(:falaq)
   bambang = users(:bambang)
 
   #Post from followed user
   falaq.microposts.each do |post_following|
     assert falaq.feed.include?(post_following)
   end
   #Post from self
   holil.microposts.each do |post_self|
     assert holil.feed.include?(post_self)
   end
   #Post from unfollow uiser
   bambang.microposts.each do |post_unfollowed|
     assert_not bambang.feed.include?(post_unfollowed)
   end
  end
end
