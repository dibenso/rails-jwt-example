class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :email
      t.string :username
      t.string :password_hash

      t.timestamps null: false
    end
  end
end
