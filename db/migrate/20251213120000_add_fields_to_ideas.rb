class AddFieldsToIdeas < ActiveRecord::Migration[7.0]
  def change
    add_column :ideas, :date, :date
    add_column :ideas, :subject, :string
    add_column :ideas, :submission_method, :string
  end
end
