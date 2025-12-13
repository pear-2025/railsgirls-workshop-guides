class AddStatusToIdeas < ActiveRecord::Migration[7.1]
  def change
    add_column :ideas, :status, :integer, default: 0
  end
end
