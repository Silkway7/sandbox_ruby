# frozen_string_literal: true

class User < ApplicationRecord
  # Создает виртуальный атрибут, не попадающий в БД
  attr_accessor :old_password, :remember_token

  # Специальный метод хеширования для защиты паролей
  # validations: false означает, что мы убираем стандартную валидацию и пишем свою
  has_secure_password validations: false

  # Валидация, если пароль не заполнили
  validate :password_presence

  # Валидация, проверяющая корректность введения старого пароля при его обновлении
  validate :correct_old_password, on: :update, if: -> { password.present? }

  # Пароль должен быть подтвержден, т.е. :password должен быть таким же как другое поле, значение
  # которого записывается как password_confirmation
  # allow_blank: true - при обновлении записи пользователь может не захотеть менять пароль,поэтому
  # мы должны оставлять ему возможность игнорировать заполнение этого поля
  validates :password, confirmation: true, allow_blank: true,
                       length: { minimum: 8, maximum: 70 }

  # Валидация поля email.
  # presence: true - поел не может быть пустым
  # uniqueness: true - поле должно быть уникальным
  # 'valid_email_2/email': true - подлючение валидация с помощью модуля в gem 'valid_email2', '~> 4.0'
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true

  # Валидация пароля с GitHub
  validate :password_complexity

  # Метод, генерирующий переменну-хеш для запоминания пользователя
  def remember_me
    # SecureRandom.urlsafe_base64 генерирует случайный набор символом
    self.remember_token = SecureRandom.urlsafe_base64
    # Помещаем запись в таблицу
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, digest(remember_token)
    # rubocop:enable Rails/SkipsModelValidations
  end

  # Метод, чтобы забыть пользователя
  def forget_me
    # Обновляем значение колонки на nil
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, nil
    # rubocop:enable Rails/SkipsModelValidations
    self.remember_token = nil
  end

  # Проверка передаваемого хеша с тем, что есть в БД
  def remember_token_authenticated?(remember_token)
    # Если данного дайджеста здесь нет
    return false if remember_token_digest.blank?

    BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
  end

  private # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # Создание хеша определенной сложности на основе принятой строки
  def digest(string)
    cost = if ActiveModel::SecurePassword
              .min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def correct_old_password
    # 1) password_digest_was - приписка _was говорит о том, что требуется вытащить из памяти старый
    # пароль из БД, а не тот, который устанавливают сейчас в память
    # 2) BCrypt::Password.new(password_digest_was).is_password?(old_password) сравнивает вводимый
    # старый пароль и старый пароль из БД
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end

  def password_complexity
    # Если пароль подходит по всем ограничениям или он пустой, то все в порядке
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    msg = 'complexity requirement not met. Length should be 8-70 characters and' \
          'include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'

    # Если пароль не соответствует каким то ограничениям, то создается ошибка и выводится сообщение
    errors.add :password, msg
  end

  def password_presence
    # Добавляем валидацию и сообщение, что пароль пустой, но только не в том случае, если
    # password_digest не пустой
    errors.add(:password, :blank) if password_digest.blank?
  end
end
