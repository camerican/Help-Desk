class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.references :user, foreign_key: true
      t.integer :threw
      t.integer :against
      t.integer :result

      t.timestamps
    end
  end
end
