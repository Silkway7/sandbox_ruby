# frozen_string_literal: true

# Данный файл создает записи в БД для теста, т.е. чтобы не создавать кучу записей мы
# создаем 30 записей с заголовком и телом, подключая Faker - специальные модули, формирующие
# записи с нужным кол-вом предложений и слов
30.times do
  title = Faker::Hipster.sentence(word_count: 3)
  body = Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4)
  Question.create title: title, body: body
end

# Для использования данного скрипта в консоле требуется остановить сервер и прописать
# rails db:seed
