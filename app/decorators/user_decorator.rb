# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  # Данная строка необходима, чтобы дегилиговать неизвестные методы объекту, который мы будем
  # декорировать
  delegate_all

  def name_or_email
    name.presence || email.split('@')[0]

    # Альтернативная запись кода выше -------
    # return name if name.present?
    # email.split('@')[0]
    #---------------------------------------
  end
end
