class AddUserRefToIdeas < ActiveRecord::Migration[7.1]
  def change
    # Make the user reference nullable so existing records won't break migrations.
    add_reference :ideas, :user, null: true, foreign_key: true
  end
end
