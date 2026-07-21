require "test_helper"

class SitePagesTest < ActionDispatch::IntegrationTest
  test "home renders hero and key sections" do
    get root_path
    assert_response :success
    assert_includes response.body, "Get back to"
    assert_includes response.body, "The surgeon<br>dedicated to"
    assert_includes response.body, "TREATMENT JOURNEY"
    # Hidden until real content exists (client request):
    assert_not_includes response.body, "PATIENT EDUCATION"
    assert_not_includes response.body, "OUTCOMES"
  end

  test "about renders" do
    get about_path
    assert_response :success
    assert_includes response.body, "Balhareth"
    assert_includes response.body, "How I decide"
    # Removed at client request:
    assert_not_includes response.body, "SURGICAL FOCUS"
  end

  test "specialties index renders all four conditions" do
    get specialties_path
    assert_response :success
    %w[Knee Hip Fractures Complex].each { |w| assert_includes response.body, w }
  end

  test "each condition page renders its guide" do
    Condition.all.each do |c|
      get specialty_path(c.slug)
      assert_response :success
      assert_includes response.body, ERB::Util.html_escape(c.title)
      assert_includes response.body, "When is surgery the"
    end
  end

  test "unknown condition 404s" do
    get specialty_path("shoulder")
    assert_response :not_found
  end

  test "faq renders three groups" do
    get faq_path
    assert_response :success
    assert_includes response.body, "APPOINTMENTS &amp; CLINIC"
    assert_includes response.body, "SURGERY"
    assert_includes response.body, "RECOVERY"
  end

  test "contact renders real clinic details" do
    get contact_path
    assert_response :success
    assert_includes response.body, "+966 58 377 7871"
    assert_includes response.body, "dr.balhareth@hotmail.com"
    assert_includes response.body, "Al Hamra Hospital"
  end

  test "articles and stories are hidden" do
    get "/articles"
    assert_response :not_found
    get "/stories"
    assert_response :not_found
  end
end
