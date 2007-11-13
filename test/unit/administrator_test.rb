require File.dirname(__FILE__) + '/../test_helper'

class AdministratorTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :administrators

  def test_should_create_administrator
    assert_difference Administrator, :count do
      administrator = create_administrator
      assert !administrator.new_record?, "#{administrator.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference Administrator, :count do
      u = create_administrator(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference Administrator, :count do
      u = create_administrator(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference Administrator, :count do
      u = create_administrator(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference Administrator, :count do
      u = create_administrator(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    administrators(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal administrators(:quentin), Administrator.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    administrators(:quentin).update_attributes(:login => 'quentin2')
    assert_equal administrators(:quentin), Administrator.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_administrator
    assert_equal administrators(:quentin), Administrator.authenticate('quentin', 'test')
  end

  def test_should_set_remember_token
    administrators(:quentin).remember_me
    assert_not_nil administrators(:quentin).remember_token
    assert_not_nil administrators(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    administrators(:quentin).remember_me
    assert_not_nil administrators(:quentin).remember_token
    administrators(:quentin).forget_me
    assert_nil administrators(:quentin).remember_token
  end

  protected
    def create_administrator(options = {})
      Administrator.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
