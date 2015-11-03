class AddRegistrationTokenToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :registration_token, :string
  end
end
