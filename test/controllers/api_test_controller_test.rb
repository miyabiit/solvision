require 'test_helper'

class ApiTestControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_test_index_url
    assert_response :success
  end

  test "should get create" do
    get api_test_create_url
    assert_response :success
  end

end
