namespace :content do
  desc "Export operations/blogs/FAQs (+photos) to db/content_seed/ — run in dev, then commit"
  task export: :environment do
    data = ContentSync.export!
    puts "Exported to db/content_seed/: #{data['operations'].size} operations, " \
         "#{data['blogs'].size} blogs, #{data['global_faqs'].size} global FAQs, " \
         "#{Dir[ContentSync::FILES_DIR.join('*')].size} photo files."
    puts "Commit db/content_seed/ so prod picks it up via db:seed."
  end

  desc "Import content from db/content_seed/ (also runs automatically via db:seed)"
  task import: :environment do
    abort "No dump at db/content_seed/content.json — run content:export in dev first." unless ContentSync.dump_exists?
    user = User.order(:id).first || abort("No users exist — run db:seed or create a user first.")
    data = ContentSync.import!(user: user)
    puts "Imported #{data['operations'].size} operations, #{data['blogs'].size} blogs, " \
         "#{data['global_faqs'].size} global FAQs."
  end
end
