# encoding: utf-8
# language: ru



Функционал: Проверка возможности отладки кода обработок в управляемых формах
	Как Разработчик
	Я Хочу чтобы я мог отлаживать обработки тестов без каких-либо проблем


	Сценарий: Передача списка снипетов открытой формы и последующий их вызов при выполнении шагов.

	Когда я вручную открыл форму VanessaBehavoir
	И я вручную открыл необходимую обработку для отладки
	Тогда обработка при открытии проверила все открытые окна в текущем сеансе
  И при нахождении в заголовке "VanessaBehavoir" поптыталась бы вызвать экспортную функцию 'ДобавитьВнешнийСписокПроцедур'
  И из этой процедуры при прохождении шагов был приоритет
  # описание и почему так сделано
  # т.к. внешнюю обработку мы не можем программно открыть  для отладки, но при этом если нам необходимо
  # можем вручную открыть ее, тогда будет возможность вызова отладки с форм...

  Сценарий: Получение списка сниппетов из открытых форм

  Когда я вручную открыл форму для тестирования
  И я вручную открыл форму VanessaBehavoir
  Тогда VanessaBehavoir автоматически просканировала все открытые формы
  И проверила наличие экспортной функции 'ПолучитьСписокТестов'
  И для зарегистрированных тестов поставила приоритет при выполнении шагов


