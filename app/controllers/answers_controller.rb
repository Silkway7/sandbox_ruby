# frozen_string_literal: true

class AnswersController < ApplicationController
  # Модуль для подключения dom_id
  include ActionView::RecordIdentifier

  # Порядок before_action важен, так как сначала мы должны найти вопрос, а уже потом
  # на его основе ответ(ы)
  before_action :set_question!
  # except: :create необходимо добавить, чтобы исключить поиск ответа при создании нового,
  # так как при создании ответ только создается
  before_action :set_answer!, except: :create

  def update
    # Если удается обновить данные в БД(подставив параметры и приватного метода)
    # ,то идет переадресация на страницу вопросов
    if @answer.update answer_params
      flash[:success] = 'Answer updated!'
      # Редирект на страницу вопроса с ответами.
      # anchor - якорь, который отправляет нас к редактируемому ответу(чтобы не надо
      # было мотать страницу)
      redirect_to question_path(@question, anchor: dom_id(@answer))
    else
      # В противном случае требуется отрендерить представление edit.html.erb
      render :edit
    end
  end

  def edit; end

  def create
    @answer = @question.answers.build answer_params

    if @answer.save
      flash[:success] = 'Answer created!'
      # Редирект на страницу вопроса. В качестве параметра передается id нужного вопроса
      redirect_to question_path(@question) # @question в этой строке аналогичен @question.id
    else
      # Мы определяем переменную ответов, так как при отправке пустой формы ответа
      # система попытается отрендерить представление show без данных
      @question = @question.decorate
      @answers = @question.answers.order created_at: :desc
      # Rails первоначально ищет файл в директории с названием вызываемого контроллера,
      # в данном случае answers.
      # Для рендера страницы из другой папки надо прописывать ее в путь
      render 'questions/show'
    end
  end

  def destroy
    # 1)Создаем локальную переменную, в которую из объекта вопроса среди ответов ищем тот,
    # которому соответствует переданный id
    # answer = @question.answers.find params[:id]
    # 2) Если добавлен before_action с приватной функцией определения ответа,
    # то в методе destroy не обязательно делать локальную переменную answer с ответов,
    # а нужно просто поставить @ перед методом answer.destroy
    @answer.destroy
    flash[:success] = 'Answer deleted!'
    redirect_to question_path(@question)
  end

  private

  # Вытаскиваем присланные параметры
  def answer_params
    # В присланных параметрах требуется найти ответ(:answer) и из его параметров
    # вытащить body
    # -params - это все пришедшие параметры запроса
    params.require(:answer).permit(:body)
  end

  # Метод поиска необходимого вопроса из модели по переданному id
  def set_question!
    @question = Question.find params[:question_id]
  end

  # Метод поиска ответа из ответов конкретного вопроса по переданному id
  def set_answer!
    @answer = @question.answers.find params[:id]
    # Запись ниже идентична верхней. По сути params[:id] является передаваемым параметром
    # @answer = @question.answers.find(params[:id])
  end
end
