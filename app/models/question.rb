class Question < ApplicationRecord
  # Наследует класс, позволяющий работать с данными из БД также, как с обычными классами Ruby
  # Вся логика с данными находится в моделе

  # Валидация(проверка)
  validates :title, presence: true, length: {minimum: 2}
  validates :body, presence: true, length: {minimum: 2}

  # Данный метод переводит атрибут  created_at в нужный формат даты
  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
