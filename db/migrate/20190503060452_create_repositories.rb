class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :url, null: false
      t.string :author, null: false
      t.string :project, null: false
      t.string :winners, array: true, default: []
      t.timestamps
    end
  end
end
