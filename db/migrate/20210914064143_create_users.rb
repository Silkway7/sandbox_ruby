# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      # К полю email дописываем условия, что оно не может быть пустым, также
      # index должен быть уникальным. Условия действуют на уровне БД
      t.string :email, null: false, index: { unique: true }
      t.string :name
      t.string :password_digest

      t.timestamps
    end
  end
end
