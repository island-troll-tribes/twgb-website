require 'test_helper'

class W3mmdEloScoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @w3mmd_elo_score = w3mmd_elo_scores(:one)
  end

  test "should get index" do
    get w3mmd_elo_scores_url
    assert_response :success
  end

  test "should get new" do
    get new_w3mmd_elo_score_url
    assert_response :success
  end

  test "should create w3mmd_elo_score" do
    assert_difference('W3mmdEloScore.count') do
      post w3mmd_elo_scores_url, params: { w3mmd_elo_score: { category: @w3mmd_elo_score.category, name: @w3mmd_elo_score.name, score: @w3mmd_elo_score.score, server: @w3mmd_elo_score.server } }
    end

    assert_redirected_to w3mmd_elo_score_url(W3mmdEloScore.last)
  end

  test "should show w3mmd_elo_score" do
    get w3mmd_elo_score_url(@w3mmd_elo_score)
    assert_response :success
  end

  test "should get edit" do
    get edit_w3mmd_elo_score_url(@w3mmd_elo_score)
    assert_response :success
  end

  test "should update w3mmd_elo_score" do
    patch w3mmd_elo_score_url(@w3mmd_elo_score), params: { w3mmd_elo_score: { category: @w3mmd_elo_score.category, name: @w3mmd_elo_score.name, score: @w3mmd_elo_score.score, server: @w3mmd_elo_score.server } }
    assert_redirected_to w3mmd_elo_score_url(@w3mmd_elo_score)
  end

  test "should destroy w3mmd_elo_score" do
    assert_difference('W3mmdEloScore.count', -1) do
      delete w3mmd_elo_score_url(@w3mmd_elo_score)
    end

    assert_redirected_to w3mmd_elo_scores_url
  end
end
