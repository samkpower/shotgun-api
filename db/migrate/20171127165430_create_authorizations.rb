class CreateAuthorizations < ActiveRecord::Migration[5.0]
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.references :user, index: true
      t.string :refresh_token
    end
  end
end
