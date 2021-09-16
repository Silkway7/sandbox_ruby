# frozen_string_literal: true

# В папке concerns создаются специальные подключаемые модули, например об обработке ошибки
module ErrorHandling
  # Подключение модуля ActiveSupport::Concern
  extend ActiveSupport::Concern

  # Когда модуль ErrorHandling включается в какой-то класс, то начинается обработка
  # следующего кода
  included do
    # Данная запись означает: обрабатывать ошибку типа ActiveRecord::RecordNotFound с
    # помощью метода :notfound . Сам метод пишется ниже
    rescue_from ActiveRecord::RecordNotFound, with: :notfound

    private

    # Метод отображения опредененной ошибки. Принимает exception - ошибку
    def notfound(exception)
      # logger позволяет записать сведения об ошибке в логи
      logger.warn exception
      # 1) Выдает на экран файл public/404.html. Это стандартный файл в папке public,
      # созданный автоматически при создании приложения. В нем можно менять стили,
      # сообщение и тд
      # 2) layout: false означает, что файл  public/404.html будет отображаться без
      # каких-либо дополнений
      # 3) status: :not_found - это состояние
      render file: 'public/404.html', status: :not_found, layout: false
    end
  end
end
