require "test_helper"

class SitePagesTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(name: "Admin", email: "admin@milaknights.com", password: "secret123")

    @operation = Operation.create!(
      title_en: "Knee Osteoarthritis", title_ar: "خشونة الركبة",
      slug: "knee", slug_ar: "خشونة-الركبة", category: :knee,
      description_en: "Gradual wear of the cartilage cushioning your joint.",
      description_ar: "تآكل تدريجي في الغضاريف.",
      is_published: true, user_id: @admin.id
    )
    @operation.contents.create!(content_en: "<h3>Signs that matter</h3><ul><li>Pain while walking</li></ul>",
                                content_ar: "<h3>الأعراض</h3>", is_published: true, user_id: @admin.id)
    @operation.faqs.create!(question_en: "How long does a knee replacement last?", answer_en: "20-25 years.",
                            question_ar: "كم تدوم؟", answer_ar: "20-25 سنة.", is_published: true, user: @admin)

    @draft_operation = Operation.create!(
      title_en: "Draft Op", title_ar: "مسودة", slug: "draft-op", slug_ar: "مسودة-عملية",
      is_published: false, user_id: @admin.id
    )

    Faq.create!(question_en: "Do I need a referral?", answer_en: "No, you can book directly.",
                question_ar: "هل أحتاج تحويل؟", answer_ar: "لا.", is_published: true, user: @admin)

    @blog = Blog.create!(
      title_en: "When is knee replacement the right choice?", title_ar: "متى يكون الاستبدال صحيحاً؟",
      slug: "knee-replacement-choice", slug_ar: "استبدال-الركبة", category: :knee,
      description_en: "The honest checklist.", is_published: true, user_id: @admin.id
    )
    blog_content = @blog.contents.create!(content_en: "<p>Body of the article.</p>", content_ar: "<p>نص المقال.</p>",
                                          is_published: true, user_id: @admin.id)
    content_photo = blog_content.content_photos.create!(alt_en: "Checklist illustration", alt_ar: "رسم توضيحي")
    content_photo.photo.attach(io: File.open(Rails.root.join("public/images/knee.webp")),
                               filename: "knee.webp", content_type: "image/webp")

    @draft_blog = Blog.create!(
      title_en: "Draft post", title_ar: "مسودة مقال", slug: "draft-post", slug_ar: "مسودة-مقال",
      is_published: false, user_id: @admin.id
    )
  end

  test "home renders hero and dynamic specialty cards" do
    get root_path
    assert_response :success
    assert_includes response.body, "Get back to"
    assert_includes response.body, "Knee Osteoarthritis"
    assert_not_includes response.body, "Draft Op"
  end

  test "specialties index lists only published operations" do
    get specialties_path
    assert_response :success
    assert_includes response.body, "Knee Osteoarthritis"
    assert_not_includes response.body, "Draft Op"
  end

  test "specialty page renders contents and faqs" do
    get "/specialties/#{@operation.slug}"
    assert_response :success
    assert_includes response.body, "Signs that matter"
    assert_includes response.body, "How long does a knee replacement last?"
  end

  test "draft or unknown specialty 404s" do
    get "/specialties/draft-op"
    assert_response :not_found
    get "/specialties/shoulder"
    assert_response :not_found
  end

  test "faq page renders global published faqs" do
    get faq_path
    assert_response :success
    assert_includes response.body, "Do I need a referral?"
  end

  test "articles index lists published blogs and nav shows ARTICLES" do
    get articles_path
    assert_response :success
    assert_includes response.body, "When is knee replacement the right choice?"
    assert_not_includes response.body, "Draft post"
    assert_includes response.body, ">ARTICLES<"
  end

  test "article page renders contents with their photos" do
    get "/articles/#{@blog.slug}"
    assert_response :success
    assert_includes response.body, "Body of the article."
    assert_includes response.body, "/rails/active_storage/"
    assert_includes response.body, "Checklist illustration"

    # Arabic page shows the Arabic alt/caption
    get "/ar/articles/#{@blog.slug}"
    assert_response :success
    assert_includes response.body, "رسم توضيحي"
  end

  test "content blocks are published by default; only the blog flag gates visibility" do
    block = @blog.contents.create!(content_en: "<p>Default visible.</p>", content_ar: "<p>ظاهر.</p>", user_id: @admin.id)
    assert block.is_published, "content should default to published"

    get "/articles/#{@blog.slug}"
    assert_includes response.body, "Default visible."

    @blog.update!(is_published: false)
    get "/articles/#{@blog.slug}"
    assert_response :not_found
  end

  test "draft article 404s" do
    get "/articles/#{@draft_blog.slug}"
    assert_response :not_found
  end

  test "contact renders real clinic details" do
    get contact_path
    assert_response :success
    assert_includes response.body, "+966 58 377 7871"
    assert_includes response.body, "dr.balhareth@hotmail.com"
  end

  test "api login issues jwt and guards blog index" do
    post "/login", params: { email: @admin.email, password: "secret123" }, as: :json
    assert_response :success
    token = JSON.parse(response.body)["token"]
    assert token.present?

    get "/blogs"
    assert_response :unauthorized

    get "/blogs", headers: { "Authorization" => "Bearer #{token}" }
    assert_response :success
    assert_equal 2, JSON.parse(response.body).size
  end

  test "public api endpoints need no auth" do
    get "/operations_landing"
    assert_response :success
    assert_equal 1, JSON.parse(response.body).size

    get "/operation_show/", params: { slug: @operation.slug }
    assert_response :success
    assert_equal "Knee Osteoarthritis", JSON.parse(response.body)["title_en"]

    get "/faq_about_us"
    assert_response :success
  end

  test "arabic locale renders RTL with arabic content" do
    get "/ar"
    assert_response :success
    assert_includes response.body, 'dir="rtl"'
    assert_includes response.body, "خشونة الركبة"

    get "/ar/specialties/#{@operation.slug}"
    assert_response :success
    assert_includes response.body, "خشونة الركبة"

    # Arabic slug resolves too
    get "/ar/specialties/#{ERB::Util.url_encode(@operation.slug_ar)}"
    assert_response :success
  end

  test "locale switcher links point to the same page in the other language" do
    get "/faq"
    assert_includes response.body, 'href="/ar/faq"'
    get "/ar/faq"
    assert_includes response.body, 'href="/faq"'
  end

  test "booking form saves inquiry, sends two emails, and redirects with notice" do
    assert_difference "Inquiry.count", 1 do
      assert_enqueued_with(job: InquiryNotificationJob) do
        post "/inquiries", params: { inquiry: { name: "Test Patient", mobile: "0512345678",
                                                email: "patient@example.com", reason: "Knee pain" } },
                           headers: { "HTTP_REFERER" => "http://www.example.com/contact" }
      end
    end
    assert_redirected_to "http://www.example.com/contact"
    inquiry = Inquiry.last
    assert_equal "+966512345678", inquiry.mobile
    assert_equal "en", inquiry.preferred_locale

    assert_emails 2 do
      perform_enqueued_jobs
    end
    notification, confirmation = ActionMailer::Base.deliveries.last(2)
    assert_equal [Clinic::INFO_EMAIL], notification.to
    assert_equal ["patient@example.com"], confirmation.to
  end

  test "arabic booking form stores arabic locale and invalid mobile is rejected" do
    post "/ar/inquiries", params: { inquiry: { name: "مريض", mobile: "0512345678" } },
                          headers: { "HTTP_REFERER" => "http://www.example.com/ar/contact" }
    assert_equal "ar", Inquiry.last.preferred_locale

    assert_no_difference "Inquiry.count" do
      post "/inquiries", params: { inquiry: { name: "Bad", mobile: "12345" } },
                         headers: { "HTTP_REFERER" => "http://www.example.com/contact" }
    end
  end

  test "admin inquiries page lists and toggles requests" do
    inquiry = Inquiry.create!(name: "Walk-in", mobile: "0511111111")
    post admin_login_path, params: { email: @admin.email, password: "secret123" }

    get admin_inquiries_path
    assert_response :success
    assert_includes response.body, "Walk-in"

    patch admin_inquiry_path(inquiry, handled: true)
    assert inquiry.reload.handled
  end

  test "admin requires login and works with a session" do
    get admin_root_path
    assert_redirected_to admin_login_path

    post admin_login_path, params: { email: @admin.email, password: "secret123" }
    assert_redirected_to admin_root_path

    get admin_root_path
    assert_response :success
    get admin_blogs_path
    assert_response :success
    assert_includes response.body, "When is knee replacement the right choice?"
    get admin_operations_path
    assert_response :success
    get admin_faqs_path
    assert_response :success
  end
end
