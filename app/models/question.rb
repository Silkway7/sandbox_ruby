# frozen_string_literal: true

class Question < ApplicationRecord
  # Наследует класс, позволяющий работать с данными из БД также, как с обычными классами Ruby
  # Вся логика с данными находится в моделе

  # 1) Эта запись означает, что у данной модели есть связь один ко многим с моделью Answer
  # т.е. одному вопросу могут принадлежать многие ответы
  # 2) dependent: :destroy означает, что при удалении экземпляра данной модели(вопроса),
  # удаляются и связанные с ней модели по связям один ко многим, т.е. модели ответов
  has_many :answers, dependent: :destroy

  # Валидация(проверка)
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }
end
