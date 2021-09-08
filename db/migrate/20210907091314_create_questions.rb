class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    # С помощью команды в консоле(rails g model Question title:string body:text) создается миграция, внутри которой метод create_table, создающий таблицу questions с колонками title и body. 
    # Колонка ID и timestamps создаются автоматически
    create_table :questions do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
