# frozen_string_literal: true

class QuestionDecorator < ApplicationDecorator
  delegate_all

  # Данный метод переводит атрибут  created_at в нужный формат даты
  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
