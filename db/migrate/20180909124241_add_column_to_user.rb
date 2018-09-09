class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basic_time, :datetime
    add_column :users, :specified_woking_time, :datetime
  end
end
