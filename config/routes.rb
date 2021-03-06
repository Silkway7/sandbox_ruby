# frozen_string_literal: true

Rails.application.routes.draw do
  # Обычный вид маршрутов *********************************************************
  # Страница ВСЕХ вопросов
  # для страницы localhost/questions
  # get '/questions', to: 'questions#index'

  # Страница создания нового вопроса
  # get '/questions/new', to: 'questions#new'

  # Страница редактирования вопроса
  # Вместо :id будет автоматически подставляться идентификатор из БД того вопроса
  # ,который надо отредактировать. ( : означает переменное поле)
  # get '/questions/:id/edit', to: 'questions#edit'

  # Страница обработки данных для создания нового вопроса
  # В контроллере задействуется метод create для передачи данных методом post
  # post '/questions', to: 'questions#create'
  #-------------------------------------------------------------------------------

  # Сессия ***********************************************************************
  # Если маршруты не подразумевают работу с БД, то следует писать resource в единственном числе
  # также как и :session. при подобной записи маршрут не будет требовать id
  resource :session, only: %i[new create destroy]
  # ------------------------------------------------------------------------------

  # Регистрация и редактирование пользователей ************************************
  resources :users, only: %i[new create edit update]
  # ------------------------------------------------------------------------------

  # Специальный метод для стандартных маршрутов ***********************************
  # Данный метод означает, что для questions надо создать маршруты для методов
  # в скобках
  # resources :questions, only: %i[index new edit create update destroy show]

  # Выше представлены основные 7 методов ---
  # их можно заменить следующей записью. ЕСЛИ ДОБАВЛЕНЫ ВСЕ 7
  #
  # Для вложенных связанных маршрутов ответов ---------------------------
  # Если маршруты связаны с другими логикой один ко многих, то внутренние маршруты
  # могут быть добавлены конструкцией
  # some resourses :name_of_main_resouses do
  #   resourses :not_main_resourses_name
  # end
  # ---------------------------------------------------------------------
  resources :questions do
    # only - только для маршрутов в скобках
    # except - кроме маршрутов в скобках
    resources :answers, except: %i[new show]
  end

  # ------------------------------------------------------------------------------

  # При заходе на главную страницу сайта идет обращение к контроллеру
  # pages(PagesController) в папке app/controllers
  # и использует метод index задействованного контроллера
  root 'pages#index'
end
