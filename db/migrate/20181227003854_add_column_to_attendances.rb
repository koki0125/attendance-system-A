class AddColumnToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :expected_finish_time, :datetime
    add_column :attendances, :overtime, :datetime
    add_column :attendances, :detail, :string
    add_column :attendances, :reason, :string
    add_column :attendances, :approval, :boolean
  end
end
