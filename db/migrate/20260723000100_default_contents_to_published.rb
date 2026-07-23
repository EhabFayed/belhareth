class DefaultContentsToPublished < ActiveRecord::Migration[8.0]
  def up
    # Content blocks are always live; visibility is controlled solely by the
    # parent blog/operation's is_published flag.
    change_column_default :contents, :is_published, from: false, to: true
    execute "UPDATE contents SET is_published = TRUE"
  end

  def down
    change_column_default :contents, :is_published, from: true, to: false
  end
end
