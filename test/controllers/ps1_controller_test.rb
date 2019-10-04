require 'test_helper'

class Ps1ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ps1_index_url
    assert_response :success
  end

end
