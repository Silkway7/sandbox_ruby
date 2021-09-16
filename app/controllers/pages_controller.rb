# frozen_string_literal: true

class PagesController < ApplicationController
  # 1. Создаем метод, к которому будет обращение при загрузке страницы, связанной с этим контроллером
  # 2. В методе создается переменная, в которую передается параметр name(по сути - это передаваемый GET с именем name)
  def index
    # @name = params[:name]
    # @ означает, что переменная будет видна во view, связанным с этим
    # контроллером(в данном случае views/pages/index.html.erb), а также в других методах контроллера
  end
end
