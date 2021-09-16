# frozen_string_literal: true

class SessionsController < ApplicationController
  # Проверка, авторизован ли пользователь для страниц new и create
  before_action :require_no_authentication, only: %i[new create]

  before_action :require_authentication, only: :destroy

  def new; end

  def create
    # Создаем локальную переменную, в которую передаем значение email из БД, соответствующее пере-
    # данному при заполнении формы на странице /sessions
    user = User.find_by email: params[:email]

    # 1) Метод .authenticate доступен, так как в модели user.rb добавлена строка has_secure_password
    # и он принимает строку(в данном случае пароль), конвертирует его в хеш и сверяет с тем хешем,
    # что у пользователя в БД к указанному email
    # 2) Амперсант & после user означает, что если пользователь передал не email, а пустую строку,
    # т.е. user = nil, то условие принимает значение false и переходит к выполнению else
    if user&.authenticate(params[:password])
      do_sign_in(user)
    else
      flash[:warning] = 'Incorrect email and/or password!'
      redirect_to new_session_path
    end
  end

  def destroy
    sign_out
    flash[:success] = 'See you later!'
    # root_path - главная страница
    redirect_to root_path
  end

  private

  def do_sign_in(user)
    # sign_in - это метод, взятый из папки controllers/concerns/authentication.rb и он
    # устанавливает сессионную переменную с id юзера
    sign_in user
    remember(user) if params[:remember_me] == '1'
    flash[:success] = "Welcome back to the app, #{current_user.name_or_email}"
    redirect_to root_path
  end
end
