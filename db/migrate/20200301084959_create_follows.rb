class CreateFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :follows do |t|
      t.integer :followed_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
