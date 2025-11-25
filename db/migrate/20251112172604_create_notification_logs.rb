class CreateNotificationLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :notification_logs do |t|
      t.integer :user_id
      t.string :notification_type
      t.string :status
      t.text :payload

      t.timestamps
    end
  end
end
