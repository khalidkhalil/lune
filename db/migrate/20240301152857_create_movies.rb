class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :name
      t.text :description
      t.integer :year
      t.references :director, null: false, foreign_key: true
      t.float :avergate_review 
      t.timestamps
    end
  end
end
