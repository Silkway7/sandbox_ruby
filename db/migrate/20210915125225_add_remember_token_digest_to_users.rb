# frozen_string_literal: true

class AddRememberTokenDigestToUsers < ActiveRecord::Migration[6.1]
  # Метод для запоминания пользователя
  def change
    add_column :users, :remember_token_digest, :string
  end
end
