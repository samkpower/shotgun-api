class AddScopesToAuthroizations < ActiveRecord::Migration[5.0]
  def change
    add_column :authorizations, :scopes, :string, array: true, default: '{}'
    add_index  :authorizations, :scopes, using: 'gin'
  end
end
