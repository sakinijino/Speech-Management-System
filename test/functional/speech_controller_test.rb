require File.dirname(__FILE__) + '/../test_helper'
require 'speech_controller'

# Re-raise errors caught by the controller.
class SpeechController; def rescue_action(e) raise e end; end

class SpeechControllerTest < Test::Unit::TestCase
  fixtures :speeches

  def setup
    @controller = SpeechController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = speeches(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:speeches)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:speech)
    assert assigns(:speech).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:speech)
  end

  def test_create
    num_speeches = Speech.count

    post :create, :speech => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_speeches + 1, Speech.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:speech)
    assert assigns(:speech).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Speech.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Speech.find(@first_id)
    }
  end
end
