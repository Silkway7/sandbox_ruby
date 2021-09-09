class QuestionsController < ApplicationController
  #Данный метод используется при переходе на страницу /questions
  #В методе в переменную @questions добавляются вся информация из моледи(таблицы) Question
  def index
    @questions = Question.all
  end

  #Данный метод используется при переходе на страницу /questions/new
  # В переменную @question передается новая запись для модели, данные для которой
  # передаются через форму на странице отображения
  def new
    @question = Question.new
  end

  #Метод создания нового вопроса и сохранения его в модель(БД)
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
    #Если вопрос можно сохранить в БД, то идет переход на страницу вопросов
    # по пути questions_path из routs(это имя роута из консоли)
    if @question.save
      # flash - сообщение, помещаемое в сессию и выдастся один раз. После
      # перезагрузки страницы оно появляться не будет
      # success - это ключ, а сообщение - значение
      flash[:success] = "Question created!"
      redirect_to questions_path
    else
      # В противном случае требуется отрендерить представление new.html.erb
      render :new
    end
  end

  # Метод отображения страницы редактирования вопроса с нужным id
  def edit
    #В переменную присваивается запись из модели Question, найденная
    # по id методом find_by. Сам id берется из переданных параметров params
    @question = Question.find_by id: params[:id]
  end

  # Метод редактирования вопроса
  def update
    #В переменную присваивается запись из модели Question, найденная
    # по id методом find_by. Сам id берется из переданных параметров params
    @question = Question.find_by id: params[:id]

    #Если удается обновить данные в БД(подставив параметры и приватного метода)
    # ,то идет переадресация на страницу вопросов
    if @question.update question_params
      flash[:success] = "Question updated!"
      redirect_to questions_path
    else
      # В противном случае требуется отрендерить представление edit.html.erb
      render :edit
    end
  end

  #Метод удаления вопроса
  def destroy
    #В переменную присваиваем строку данных из модели Question с id, равным тому,
    # что в строке запроса
    @question = Question.find_by id: params[:id]
    # Метод destroy отправляет запрос на удаление в БД
    @question.destroy
    flash[:success] = "Question deleted!"
    redirect_to questions_path
  end

  #Данный метод переводит на страницу с отображением конкретного элемента
  def show
    @question = Question.find_by id: params[:id]
  end

  #Закрытые методы идут после строки private
  private

  #Вытаскиваем присланные параметры
  def question_params
    # В присланных параметрах требуется найти вопрос(:question) и из его параметров
    # вытащить title и body
    # -params - это все пришедшие параметры запроса
    params.require(:question).permit(:title, :body)
  end
end
# localhost/questions