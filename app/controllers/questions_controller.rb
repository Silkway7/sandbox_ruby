# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question!, only: %i[show destroy edit update]
  # Данный метод используется при переходе на страницу /questions
  # В методе в переменную @questions добавляются вся информация из моледи(таблицы) Question
  def index
    # 1) Подключенный модуль kaminari дает возможность пользоваться методом page,который
    # разбивает коллекцию на страницы и далее через params[:page] определяется, к
    # какой странице обращается пользователь
    # 2) Метод order(created_at: :desc) сортирует данные коллекции по отрибуту created_at
    # в порядке убывания
    # @questions = Question.order(created_at: :desc).page params[:page]

    # Следующая строка - пагинация с помощью модуля Pagy
    @pagy, @questions = pagy Question.order(created_at: :desc)
    @questions = @questions.decorate

    # Следующая строка - выбор всех данных модели без сортировки
    # @questions = Question.all.page params[:page]
  end

  # Данный метод используется при переходе на страницу /questions/new
  # В переменную @question передается новая запись для модели, данные для которой
  # передаются через форму на странице отображения
  def new
    @question = Question.new
  end

  # Метод создания нового вопроса и сохранения его в модель(БД)
  def create
    # ОТОБРАЖЕНИЕ ПРИШЕДШИХ ДАННЫХ ИЗ ФОРМ ------------------------------
    # -render - в отличие от методов выше он не просто ищет представление
    # во views, а пытается отобразить нечто иное со своей логикой
    # -plain - выдать обычный текст, внутри которого будут передаваемые параметры
    # -params - это все пришедшие параметры запроса
    # render plain: params
    # -------------------------------------------------------------------

    # В переменную @question создается новый объект Question и с помощью метода
    # question_params, созданного ниже, в него добавляются нужные параметры
    @question = Question.new question_params
    # Если вопрос можно сохранить в БД, то идет переход на страницу вопросов
    # по пути questions_path из routs(это имя роута из консоли)
    if @question.save
      # flash - сообщение, помещаемое в сессию и выдастся один раз. После
      # перезагрузки страницы оно появляться не будет
      # success - это ключ, а сообщение - значение
      flash[:success] = 'Question created!'
      redirect_to questions_path
    else
      @question.decorate
      # В противном случае требуется отрендерить представление new.html.erb
      render :new
    end
  end

  # Метод отображения страницы редактирования вопроса с нужным id
  def edit; end

  # Метод редактирования вопроса
  def update
    # Если удается обновить данные в БД(подставив параметры и приватного метода)
    # ,то идет переадресация на страницу вопросов
    if @question.update question_params
      flash[:success] = 'Question updated!'
      redirect_to questions_path
    else
      # В противном случае требуется отрендерить представление edit.html.erb
      render :edit
    end
  end

  # Метод удаления вопроса
  def destroy
    # Метод destroy отправляет запрос на удаление в БД
    @question.destroy
    flash[:success] = 'Question deleted!'
    redirect_to questions_path
  end

  # Данный метод переводит на страницу с отображением конкретного элемента
  def show
    # Получаем и декорируем вопрос с помощью декоратора
    @question = @question.decorate
    # В памяти создается новый образец класса(модели) Answer
    # build связывает образец с вопросом @question
    @answer = @question.answers.build

    # Создается переменная в которую помещаются данные об ответах конкретного вопроса
    # и они сортируются методом order по полю created_at в порядке убывания(:desc)
    # .per(2) - указывает, по сколько ответов показывать на странице пагинации
    # @answers = @question.answers.order(created_at: :desc).page(params[:page]).per(5)

    # Следующая строка - пагинация с помощью модуля Pagy
    @pagy, @answers = pagy @question.answers.order(created_at: :desc)
    @answers = @answers.decorate
    # Другой способ достать в переменную все ответы
    # "найти все ответы из модели Answer, где question_id = @question.id"
    # @answers = Answer.where(question_id: @question.id)
  end

  # Закрытые методы идут после строки private
  private

  # Вытаскиваем присланные параметры
  def question_params
    # В присланных параметрах требуется найти вопрос(:question) и из его параметров
    # вытащить title и body
    # -params - это все пришедшие параметры запроса
    params.require(:question).permit(:title, :body)
  end

  # Метод присваивания id записи в переменную по передаваемому значению из запроса
  def set_question!
    # В переменную присваивается запись из модели Question, найденная
    # по id методом find_by. Сам id берется из переданных параметров params
    # @question = Question.find_by id: params[:id]

    # Альтернативный способ поиска id, который решает ошибку, если идет переход к вопросу
    # с несуществующим id
    @question = Question.find params[:id]
  end
end
# localhost/questions
