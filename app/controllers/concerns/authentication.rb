# frozen_string_literal: true

# В папке concerns создаются специальные подключаемые модули, например об обработке ошибки
module Authentication
  # Подключение модуля ActiveSupport::Concern
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    private

    # Метод установки авторизации пользователя
    def current_user
      user = session[:user_id].present? ? user_from_session : user_from_token
      # Амперсант & после user означает, что если user = nil, то метод decorate
      # вызываться не будет
      @current_user ||= user&.decorate
    end

    # Поиск юзера из сессии
    def user_from_session
      User.find_by(id: session[:user_id])
    end

    # Поиск юзера из токена
    def user_from_token
      user = User.find_by(id: cookies.encrypted[:user_id])
      token = cookies.encrypted[:remember_token]

      return unless user&.remember_token_authenticated?(token)

      sign_in(user)
      user
    end

    # Данный метод проверяет, установлена ли авторизация пользователя
    def user_signed_in?
      current_user.present?
    end

    def require_authentication
      # Если текущий пользователь авторизован, то выполянется метод user_signed_in?
      return if user_signed_in?

      # В противном пользователя перебрасывает на главную страницу
      flash[:warning] = 'You are not signed in!'
      redirect_to root_path
    end

    # Проверка авторизации для нужных страниц.
    def require_no_authentication
      # Если текущий пользователь не авторизован, то выполянется метод user_signed_in?
      return unless user_signed_in?

      # В противном пользователя перебрасывает на главную страницу
      flash[:warning] = 'You are already signed in!'
      redirect_to root_path
    end

    # Метод, создающий сессионную переменную с ID пользователя
    def sign_in(user)
      # Создаем сессионную переменную, чтобы проверять авторизацию пользователя
      session[:user_id] = user.id
    end

    # Запоминание пользователя
    def remember(user)
      user.remember_me
      # Передаем в куки значение токена
      cookies.encrypted.permanent[:remember_token] = user.remember_token
      # Передаем в куки user_id
      cookies.encrypted.permanent[:user_id] = user.id
    end

    def forget(user)
      # Метод обновляет значение в БД на nil
      user.forget_me
      # Удаляем из куки id юзера и токен
      cookies.delete :user_id
      cookies.delete :remember_token
    end

    # Метод, удаляющий сессионную переменную с ID пользователя
    def sign_out
      forget current_user
      session.delete :user_id
      @current_user = nil
    end

    # Данный метод позволяет методам :current_user, :user_signed_in? быть доступными не только
    # в контроллерах, но и в представлениях
    helper_method :current_user, :user_signed_in?
  end
  # rubocop:enable Metrics/BlockLength
end
