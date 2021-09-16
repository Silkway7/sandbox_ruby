# frozen_string_literal: true

class UsersController < ApplicationController
  # Проверка, авторизован ли пользователь
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: %i[edit update]
  before_action :set_user!, only: %i[edit update]

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = 'Your profile was successfully updated!'
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def new
    @user = User.new
  end

  def create
    # Создаем переменную, в которую передается информация по модели с параметрами из запроса для
    # сохранения в БД
    @user = User.new(user_params)
    # Если удается сохранить данные в БД, то перенаправляем пользователя на главную страницу
    if @user.save
      # sign_in - это метод, взятый из папки controllers/concerns/authentication.rb и он
      # устанавливает сессионную переменную с id юзера. Передаем в него id пользователя
      sign_in @user
      flash[:success] = "Welcome to the app, #{current_user.name_or_email}"
      redirect_to root_path
    else
      # Если не удается сохранить данные, то рендерим заного форму ввода
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :old_password)
  end

  def set_user!
    @user = User.find params[:id]
  end
end
