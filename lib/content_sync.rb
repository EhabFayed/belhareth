# Content export/import between environments (same idea as neuskin's
# content:seed): `content:export` in dev writes db/content_seed/ (JSON +
# photo files, committed to git); `db:seed` / `content:import` on any other
# environment recreates the exact same content there.
#
# Scope: operations, blogs (with content blocks + photos + nested FAQs) and
# global FAQs. Users and inquiries are intentionally NOT copied.
module ContentSync
  DUMP_DIR  = Rails.root.join("db", "content_seed")
  JSON_PATH = DUMP_DIR.join("content.json")
  FILES_DIR = DUMP_DIR.join("files")

  RECORD_ATTRS = %w[
    title_ar title_en description_ar description_en
    image_alt_text_ar image_alt_text_en meta_title_ar meta_title_en
    slug slug_ar meta_description_ar meta_description_en is_published category
  ].freeze

  module_function

  def dump_exists?
    JSON_PATH.exist?
  end

  # ── Export (run in dev) ────────────────────────────────────────────────

  def export!
    FileUtils.rm_rf(FILES_DIR)
    FileUtils.mkdir_p(FILES_DIR)

    data = {
      "exported_at" => Time.current.iso8601,
      "operations"  => Operation.not_deleted.order(:id).map { |op| record_hash(op, op.operation_photos, extra_photo_key: "is_landing") },
      "blogs"       => Blog.not_deleted.order(:id).map { |b| record_hash(b, b.blog_photos, extra_photo_key: "is_arabic") },
      "global_faqs" => Faq.global.where(is_deleted: false).order(:id).map { |f| faq_hash(f) }
    }

    JSON_PATH.write(JSON.pretty_generate(data))
    data
  end

  def record_hash(record, photos, extra_photo_key:)
    h = record.attributes.slice(*RECORD_ATTRS)
    h["category"] = record.category&.to_s
    h["photos"]   = photos.select { |p| p.photo.attached? }.map { |p| photo_hash(p, extra_photo_key) }
    h["contents"] = record.contents.where(is_deleted: false).order(:id).map do |c|
      {
        "content_en" => c.content_en,
        "content_ar" => c.content_ar,
        "photos"     => c.content_photos.select { |cp| cp.photo.attached? }.map { |cp| photo_hash(cp, nil) }
      }
    end
    h["faqs"] = record.faqs.where(is_deleted: false).order(:id).map { |f| faq_hash(f) }
    h
  end

  def photo_hash(photo_record, extra_key)
    blob = photo_record.photo.blob
    stored = "#{blob.key}#{File.extname(blob.filename.to_s)}"
    photo_record.photo.open do |file|
      FileUtils.cp(file.path, FILES_DIR.join(stored))
    end
    h = {
      "file"         => stored,
      "filename"     => blob.filename.to_s,
      "content_type" => blob.content_type,
      "alt_en"       => photo_record.alt_en,
      "alt_ar"       => photo_record.alt_ar
    }
    h[extra_key] = photo_record.public_send(extra_key) if extra_key
    h
  end

  def faq_hash(faq)
    {
      "question_en" => faq.question_en, "answer_en" => faq.answer_en,
      "question_ar" => faq.question_ar, "answer_ar" => faq.answer_ar,
      "is_published" => faq.is_published
    }
  end

  # ── Import (run on prod via db:seed or content:import) ────────────────
  # Records are matched by slug; their photos/contents/FAQs are REPLACED so
  # the target ends up identical to the export. Content edited directly on
  # the target for those records will be overwritten.

  def import!(user:)
    data = JSON.parse(JSON_PATH.read)

    data.fetch("operations", []).each { |h| import_record(Operation, h, user, photo_assoc: :operation_photos, extra_photo_key: "is_landing") }
    data.fetch("blogs", []).each      { |h| import_record(Blog, h, user, photo_assoc: :blog_photos, extra_photo_key: "is_arabic") }

    Faq.global.destroy_all
    data.fetch("global_faqs", []).each do |f|
      Faq.create!(f.merge("user_id" => user.id))
    end

    data
  end

  def import_record(klass, h, user, photo_assoc:, extra_photo_key:)
    record = klass.find_or_initialize_by(slug: h["slug"])
    record.assign_attributes(h.slice(*RECORD_ATTRS))
    record.user_id ||= user.id
    record.is_deleted = false
    record.save!

    record.public_send(photo_assoc).destroy_all
    h.fetch("photos", []).each do |p|
      photo = record.public_send(photo_assoc).create!(
        "alt_en" => p["alt_en"], "alt_ar" => p["alt_ar"],
        extra_photo_key => p[extra_photo_key]
      )
      attach_file(photo, p)
    end

    record.contents.destroy_all
    h.fetch("contents", []).each do |c|
      content = record.contents.create!(content_en: c["content_en"], content_ar: c["content_ar"], user_id: user.id)
      c.fetch("photos", []).each do |p|
        cp = content.content_photos.create!(alt_en: p["alt_en"], alt_ar: p["alt_ar"])
        attach_file(cp, p)
      end
    end

    record.faqs.destroy_all
    h.fetch("faqs", []).each do |f|
      record.faqs.create!(f.merge("user_id" => user.id))
    end
  end

  def attach_file(photo_record, p)
    path = FILES_DIR.join(p["file"])
    return unless File.exist?(path)

    photo_record.photo.attach(io: File.open(path), filename: p["filename"], content_type: p["content_type"])
    photo_record.save!
  end
end
