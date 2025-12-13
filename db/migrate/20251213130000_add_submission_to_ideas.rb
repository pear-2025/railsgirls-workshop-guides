class AddSubmissionToIdeas < ActiveRecord::Migration[7.1]
  def change
    add_column :ideas, :submission, :integer, default: 0
  end
end
