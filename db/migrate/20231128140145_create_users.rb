class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :otp_secret_key
      t.boolean :two_fa_enabled

      t.timestamps null: false
    end
  end
end
