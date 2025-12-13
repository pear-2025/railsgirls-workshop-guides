class CreateWorkLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :work_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :idea, null: true, foreign_key: true
      t.date :work_date, null: false
      t.float :work_hours, null: false
      t.string :task_name
      t.text :description

      t.timestamps
    end

    add_index :work_logs, [:user_id, :work_date]
  end
end
