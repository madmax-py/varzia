class EnableExtensions < ActiveRecord::Migration[8.1]
  def change
    # Case-insensitive text for username and email.
    enable_extension "citext"
  end
end
