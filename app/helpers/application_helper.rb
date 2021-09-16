# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  # Хелпер - вспомогательная подключаемая функция
  # Данный файл - главный хелпер. В него добавляются хелперы, которые нужно добавить
  # на все страницы

  def pagination(obj)
    # rubocop:disable Rails/OutputSafety
    raw(pagy_bootstrap_nav(obj)) if obj&.pages.to_i > 1
    # rubocop:enable Rails/OutputSafety
  end

  # Метод принимает атрибуты ссылки
  def nav_tab(title, url, options = {})
    # Из переданных опций по ключу находится current_page, а сам ключ удаляется из хэша
    current_page = options.delete :current_page

    # В зависимости от того, равна ли текущая страницу тайтлу ссылки передаем в
    # переменную нужное значение
    css_class = current_page == title ? 'text-secondary' : 'text-white'

    # Модифицируем класс передаваемой ссылки. Если класс есть, то добавляем к нему
    # найденный заранее параметр css_class, в противном случае назначаем просто css_class
    options[:class] = if options[:class]
                        "#{options[:class]} #{css_class}"
                      else
                        css_class
                      end

    link_to title, url, options
  end

  # Данный метод получает название конкретной страницы и если оно есть, то
  # пристыковывает его к базовому названию(base_title)
  def full_title(page_title = '')
    base_title = 'Sandbox'
    # present? - проверяет, установлено ли значение данной переменной
    if page_title.present?
      "#{page_title} | #{base_title}"
    else
      base_title
    end
  end

  # Хелпер, подсвечивающий актуальную страницу
  def currently_at(current_page = '')
    # Если писать просто render без partial, то на экран будет выводиться и страница
    # layout, что неверно
    # Создаем локальную переменную current_page, в которую передается значение из
    # <% currently_at 'Questions' %>
    render partial: 'shared/menu', locals: { current_page: current_page }
  end
end
