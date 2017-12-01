class AddAccessTokenToAuthorizations < ActiveRecord::Migration[5.0]
  def change
    add_column :authorizations, :access_token, :string
  end
end
