# frozen_string_literal: true

# От данного контроллера наследуются все остальные и принимают его внутренние методы
class ApplicationController < ActionController::Base
  include Pagy::Backend
  # Подключение специального модуля из папки concerns для обработки специальной ошибки,
  # если что-то не найдено(например, переход к несуществующему вопросу)
  include ErrorHandling

  # Подключение модуля из папки concern, проверяющего авторизацию пользователя
  include Authentication
end
