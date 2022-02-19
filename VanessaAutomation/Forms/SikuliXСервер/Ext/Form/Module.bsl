﻿&НаКлиенте
Перем Ванесса;

#Область ЭкспортныеПроцедурыИФункции

&НаКлиенте
Процедура ЗапуститьSikuliXСевер(ВанессаФорма,ДопПараметры) Экспорт
	Ванесса = ВанессаФорма;
	
	КаталогиСкриптовSikuliX = Ванесса.Объект.КаталогиСкриптовSikuliX;
	Если НЕ ЗначениеЗаполнено(КаталогиСкриптовSikuliX) Тогда
		ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("Не указано значение настройки Vanessa-automation: <КаталогиСкриптовSikuliX>.");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;	 
	
	Если Найти(КаталогиСкриптовSikuliX,";") > 0 Тогда
		МассивКаталоговДляОбработки = Ванесса.РазложитьСтрокуВМассивПодстрок(КаталогиСкриптовSikuliX,";");
	Иначе	
		МассивКаталоговДляОбработки = Новый Массив;
		МассивКаталоговДляОбработки.Добавить(КаталогиСкриптовSikuliX);
	КонецЕсли;	 
	
	Для Каждого Стр Из МассивКаталоговДляОбработки Цикл
		Если НЕ Ванесса.ФайлСуществуетКомандаСистемы(Стр) Тогда
			ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("Файл <%1> не существует.");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", Стр); 
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;	
	КонецЦикла;	 
	
	ИмяСобранногоСкрипта = ИмяИтогоСкрипта();
	
	КаталогНовогоСкрипта = Ванесса.ДополнитьСлешВПуть(МассивКаталоговДляОбработки[0]) + ИмяСобранногоСкрипта + ".sikuli";
	Ванесса.СоздатьКаталогКомандаСистемы(КаталогНовогоСкрипта);
	ОчиститьКаталог(КаталогНовогоСкрипта);
	
	ДанныеСкриптов    = Новый Массив;
	ОбщаяСекцияИмпорт = Новый Массив;
	ОбщаяСекцияИмпорт.Добавить("import os");
	ОбщаяСекцияИмпорт.Добавить("import os.path");
	ОбщаяСекцияИмпорт.Добавить("import shutil");
	ОбщаяСекцияИмпорт.Добавить("import json");
	
	Для Каждого ТекКаталогСкриптовДляОбработки Из МассивКаталоговДляОбработки Цикл
		Если НЕ ЗначениеЗаполнено(ТекКаталогСкриптовДляОбработки) Тогда
			Продолжить;
		КонецЕсли;	 
		
		СписокКаталогов = Новый СписокЗначений;
		СписокФайлов    = Новый СписокЗначений;
		Ванесса.НайтиФайлыКомандаСистемы(ТекКаталогСкриптовДляОбработки, СписокКаталогов, СписокФайлов, Истина);
		Ванесса.ОставитьТолькоФайлыСРасширением(СписокКаталогов,".sikuli");
		
		Для Каждого ФайлКаталогСкрипта Из СписокКаталогов Цикл
			Если УниверсальноеПолноеИмяФайла(ФайлКаталогСкрипта.Значение.ПолноеИмя,Истина) = УниверсальноеПолноеИмяФайла(КаталогНовогоСкрипта,Истина) Тогда
				Продолжить;
			КонецЕсли;	 
			
			ДанныеСкрипта = ДанныеСкрипта(ФайлКаталогСкрипта.Значение.ПолноеИмя,ОбщаяСекцияИмпорт);
			Если ДанныеСкрипта <> Неопределено Тогда 
				Если ДанныеСкрипта.ТелоСкрипта.Количество() > 0 Тогда
					ДанныеСкриптов.Добавить(ДанныеСкрипта);
				КонецЕсли;	
			КонецЕсли;	 
		КонецЦикла;	
		
	КонецЦикла;	 
	
	ИмяФайлаСкрипта = Ванесса.ДополнитьСлешВПуть(КаталогНовогоСкрипта) + ИмяСобранногоСкрипта + ".py";
	Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.ПутьКСкрипту", ИмяФайлаСкрипта);
	ЗТ = Новый ЗаписьТекста(ИмяФайлаСкрипта, "Windows-1251", , Ложь); 
	ЗТ.Закрыть();//убираю BOM
	
	ТекстСкрипта = Новый ЗаписьТекста(ИмяФайлаСкрипта, "UTF-8", , Истина); 
	СтрокаСкрипта0 = "";
	Для Каждого СтрокаСекцияИмпорт Из ОбщаяСекцияИмпорт Цикл
		СтрокаСкрипта0 = СтрокаСкрипта0 + СтрокаСекцияИмпорт + Символы.ПС;
	КонецЦикла;	 
	СтрокаСкрипта0 = СтрокаСкрипта0 + Символы.ПС;
	ТекстСкрипта.ЗаписатьСтроку(СтрокаСкрипта0);
	
	СтрокаСкриптаСлужебнаяЧасть = "
	|sys_argv_1 = ''
	|sys_argv_2 = ''
	|sys_argv_3 = ''
	|sys_argv_4 = ''
	|sys_argv_5 = ''
	|
	|def CallError(ScriptName):
	|    pass
	|
	|def read_comand(dataofcomandlocal):
	|    global sys_argv_1
	|    global sys_argv_2
	|    global sys_argv_3
	|    global sys_argv_4
	|    global sys_argv_5
	|    sys_argv_1 = dataofcomandlocal['sys_argv_1']
	|    sys_argv_2 = dataofcomandlocal['sys_argv_2']
	|    sys_argv_3 = dataofcomandlocal['sys_argv_3']
	|    sys_argv_4 = dataofcomandlocal['sys_argv_4']
	|    sys_argv_5 = dataofcomandlocal['sys_argv_5']
	|
	|def DoResponse(response_filename,str):
	|    temp_name = response_filename + ""_temp""
	|    if os.path.exists(temp_name):
	|        os.remove(temp_name)
	|    data = {}  
	|    data['Response'] = str
	|    with open(temp_name, 'w') as outfile:
	|        json.dump(data, outfile)
	|    if os.path.exists(response_filename):
	|        os.remove(response_filename)
	|    shutil.move(temp_name, response_filename)
	|    #oldfile = io.File(response_filename)
	|    #oldfile.renameTo(response_filename)
	|    #os.rename(response_filename, response_filename)
	|    #logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)
	|    #logging.debug(response_filename)
	|
	|";
	ТекстСкрипта.ЗаписатьСтроку(СтрокаСкриптаСлужебнаяЧасть);
	
	Для Каждого ДанныеСкрипта Из ДанныеСкриптов Цикл
		СтрокаВставкиСкрипта = "
	|def %1():";
		СтрокаВставкиСкрипта = СтрЗаменить(СтрокаВставкиСкрипта,"%1",Ванесса.Транслит(ДанныеСкрипта.ИмяСкрипта));
		Для Каждого СтрокаТелоСкрипта Из ДанныеСкрипта.ТелоСкрипта Цикл
			СтрокаВставкиСкрипта = СтрокаВставкиСкрипта + Символы.ПС + "    " + СтрокаТелоСкрипта;
		КонецЦикла;	 
		ТекстСкрипта.ЗаписатьСтроку(СтрокаВставкиСкрипта);
	КонецЦикла;
	
	СтрокаСкрипта1 = "
	|
	|comand_filename   = sys.argv[1]
	|response_filename = sys.argv[2]
	|DoResponse(response_filename,""sikulix server started"")
	|NeetToExit = False
	|
	|while True:
	|    try:
	|        if not os.path.exists(comand_filename):
	|            sleep(0.3)
	|            continue
	|    except:
	|            continue
	|    
	|    
	|    with open(comand_filename) as data_file_comand:    
	|            dataofcomand = json.load(data_file_comand)
	|            comand = dataofcomand['comand']
	|            if comand == ""exit0"":
	|                NeetToExit = True
	|                break
	|
	|";
	
	ТекстСкрипта.ЗаписатьСтроку(СтрокаСкрипта1);
	
	Для Каждого ДанныеСкрипта Из ДанныеСкриптов Цикл
		СтрокаВставкиСкрипта = "
	|            elif comand == ""%1"":
	|                read_comand(dataofcomand)
	|                %1()
	|                DoResponse(response_filename,'success')
	|";
		СтрокаВставкиСкрипта = СтрЗаменить(СтрокаВставкиСкрипта,"%1",Ванесса.Транслит(ДанныеСкрипта.ИмяСкрипта));
		ТекстСкрипта.ЗаписатьСтроку(СтрокаВставкиСкрипта);
	КонецЦикла;	 
	
	СтрокаСкрипта2 = "
	|
	|    #f.close()
	|    os.remove(comand_filename)
	|        
	|    if NeetToExit:
	|        break
	|            
	|    sleep(0.3)        
	|
	|
	|exit(0)
	|";
	
	ТекстСкрипта.ЗаписатьСтроку(СтрокаСкрипта2);
	ТекстСкрипта.Закрыть();
	
	ИмяУправляющиегоФайла = ПолучитьИмяВременногоФайла("txt");
	ИмяФайлаОтвета        = ПолучитьИмяВременногоФайла("txt");
	
	СтрокаКоманды = """" + КаталогНовогоСкрипта + """ --args ""%1"" ""%2""";
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды,"%1",ИмяУправляющиегоФайла);
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды,"%2",ИмяФайлаОтвета);
	ОписаниеОшибки = "";
	ДопПараметрыКоманды = Новый Структура;
	ДопПараметрыКоманды.Вставить("СлужебныйВызов",Истина);
	ДопПараметрыКоманды.Вставить("ИмяФайлаВыводаКонсоли","");
	Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.СтрокаКоманды", СтрокаКоманды);
	Рез = Ванесса.ВыполнитьSikuliСкрипт(СтрокаКоманды, 0, ,ОписаниеОшибки,ДопПараметрыКоманды);
	
	Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда
		Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.ОписаниеОшибки", ОписаниеОшибки);
	КонецЕсли;	 
	
	SikuliXСеверЗапущен = Ложь;
	Если Рез = 0 Тогда
		//надо дождаться файла ответа сервера
		КоличествоСекундОжиданияОтвета = 20;
		КоличествоСекундОжиданияОтвета = Ванесса.ЗначениеТаймаутаДляАсинхронногоШага(КоличествоСекундОжиданияОтвета);
		ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("Значение таймаута: %1.");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1",КоличествоСекундОжиданияОтвета);
		Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.ТаймаутЗапуска", ТекстСообщения);
		
		Для СчетчикСекунд = 1 По КоличествоСекундОжиданияОтвета Цикл
			Если Ванесса.ФайлСуществуетКомандаСистемы(ИмяФайлаОтвета) Тогда
				Попытка
					Ответ = ПрочитатьФайлОтвета(ИмяФайлаОтвета);
					Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.Ответ", Ответ);
				Исключение
					Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.Ответ", Ванесса.ПолучитьТекстСообщенияПользователю("Не получилось прочитать данные из файла ответа."));
					Ванесса.sleep(1);
					Продолжить;
				КонецПопытки;
				
				Ванесса.УдалитьФайлыКомандаСистемы(ИмяФайлаОтвета);
				
				Если Ответ = "sikulix server started" Тогда
					SikuliXСеверЗапущен = Истина;
					Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.Запуск",
						Ванесса.ПолучитьТекстСообщенияПользователю("SikuliX сервер успешно запущен."));
					Прервать;
				КонецЕсли;	 
			КонецЕсли;	 
			
			Ванесса.sleep(1);
		КонецЦикла;	
		
	Иначе
		ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("Не получилось запустить Sikulix сервер.") + Символы.ПС + ОписаниеОшибки;
		Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.ОшибкаЗапуска", ТекстСообщения);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;	 
	
	Если НЕ ПустаяСтрока(ДопПараметрыКоманды.ИмяФайлаВыводаКонсоли) Тогда
		Если Ванесса.ФайлСуществуетКомандаСистемы(ДопПараметрыКоманды.ИмяФайлаВыводаКонсоли) Тогда
			Попытка
				Текст = Новый ЧтениеТекста;
				Текст.Открыть(ДопПараметрыКоманды.ИмяФайлаВыводаКонсоли,,,,Ложь);
				ВыводаКонсоли = Текст.Прочитать();
				Текст.Закрыть();
				
				Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.ВыводКонсоли", ВыводаКонсоли);
			Исключение
				Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.ВыводКонсоли",
					Ванесса.ПолучитьТекстСообщенияПользователю("Не получилось прочитать вывод консоли."));
			КонецПопытки;
		КонецЕсли;	 
	КонецЕсли;	 
	
	ДопПараметры.Вставить("SikuliXСеверЗапущен",SikuliXСеверЗапущен);
	ДопПараметры.Вставить("ИмяУправляющиегоФайла",ИмяУправляющиегоФайла);
	ДопПараметры.Вставить("ИмяФайлаОтвета",ИмяФайлаОтвета);
	ДопПараметры.Вставить("ИмяФайлаВыводаКонсолиSikuliXСервер",ДопПараметрыКоманды.ИмяФайлаВыводаКонсоли);
КонецПроцедуры 

&НаКлиенте
Функция ЕстьОшибкаВВыполненииСкрипта(ИмяФайла)
	Текст = Новый ЧтениеТекста;
	Попытка
		Текст.Открыть(ИмяФайла,"UTF-8",,, Ложь);
		Лог = Текст.Прочитать();
		Текст.Закрыть();
		
		Если Найти(Лог,"[error] Error caused by") > 0 Тогда
			ОстановитьSikuliXСервер();
			Ванесса.СброситьФлагЗапускаSikuliXServer();
			Возврат Истина;
		КонецЕсли;	 
	Исключение
		Ванесса.Отладка(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Ложь;
КонецФункции 

&НаКлиенте
Функция ВыполнитьСкрипт(СтрокаКоманды, ЖдатьОкончания, ЗапускЧерезСкрипт,ОписаниеОшибки,ДопПараметры) Экспорт
	ИмяУправляющиегоФайлаSikuliXСервер = Ванесса.ИмяУправляющиегоФайлаSikuliXСервер();
	Ванесса.УдалитьФайлыКомандаСистемы(ИмяУправляющиегоФайлаSikuliXСервер);
	
	ЗаписатьУправляющийJson(ИмяУправляющиегоФайлаSikuliXСервер,СтрокаКоманды);
	
	ИмяФайлаВыводаКонсолиSikuliXСервер = Ванесса.ИмяФайлаВыводаКонсолиSikuliXСервер();
	
	Если ЖдатьОкончания Тогда
	//ждём файла ответа
		КоличествоПопытокЧтенияОтвета = 20;
		Если ТипЗнч(ДопПараметры) = Тип("Структура") Тогда
			Если ДопПараметры.Свойство("Таймаут") Тогда
				КоличествоПопытокЧтенияОтвета = Макс(КоличествоПопытокЧтенияОтвета,ДопПараметры.Таймаут);
			КонецЕсли;	 
		КонецЕсли;	 
		
		Ответ = Неопределено;
		ИмяФайлаОтветаSikuliXСевер = Ванесса.ИмяФайлаОтветаSikuliXСевер();
		Для СчетчикПопыток = 1 По КоличествоПопытокЧтенияОтвета Цикл
			Если Ванесса.ФайлСуществуетКомандаСистемы(ИмяФайлаОтветаSikuliXСевер) Тогда
				Ответ = ПрочитатьФайлОтвета(ИмяФайлаОтветаSikuliXСевер);
				Ванесса.УдалитьФайлыКомандаСистемы(ИмяФайлаОтветаSikuliXСевер);
				Прервать;
			КонецЕсли;	
			
			Если ЕстьОшибкаВВыполненииСкрипта(ИмяФайлаВыводаКонсолиSikuliXСервер) Тогда
				Прервать;
			КонецЕсли;	 
			
			Ванесса.sleep(1);
		КонецЦикла;	
		
		Если Ответ = Неопределено Тогда
			ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("Не получилось дождаться выполнения SikuliX скрипта <%1>.");
			ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1",СтрокаКоманды); 
			ВыводКонсоли = ВыводКонсолиSikuliXСервер();
			Если ЗначениеЗаполнено(ВыводКонсоли) Тогда
				ТекстСообщения = ТекстСообщения + Символы.ПС + Символы.ПС + ВыводКонсоли;
			КонецЕсли;	 
			
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;	
		
		Если Нрег(Ответ) <> "success" Тогда
			ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("Не получилось выполнить SikuliX скрипт <%1>.");
			ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1",СтрокаКоманды); 
			ВыводКонсоли = ВыводКонсолиSikuliXСервер();
			Если ЗначениеЗаполнено(ВыводКонсоли) Тогда
				ТекстСообщения = ТекстСообщения + Символы.ПС + Символы.ПС + ВыводКонсоли;
			КонецЕсли;	 
			
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;	 
	КонецЕсли;	 
	
	Возврат 0;
КонецФункции	 

&НаКлиенте
Процедура ОстановитьSikuliXСервер(ДопПараметры = Неопределено) Экспорт
	ИмяУправляющиегоФайлаSikuliXСервер = Ванесса.ИмяУправляющиегоФайлаSikuliXСервер();
	ЗаписатьУправляющийJson(ИмяУправляющиегоФайлаSikuliXСервер,"","exit0");
	
	ЗаписьВЖР = Истина;
	Если ТипЗнч(ДопПараметры) = Тип("Структура") Тогда
		Если ДопПараметры.Свойство("ПриЗакрытии") Тогда
			ЗаписьВЖР = Ложь;
		КонецЕсли;	 
	КонецЕсли;	 
	
	Если ЗаписьВЖР Тогда
		Ванесса.ЗаписатьЛогВЖРИнформация("SikuliXСевер.ОстановкаSikuliXСервера", "");
	КонецЕсли;	 
КонецПроцедуры 

// Делает отключение модуля
&НаКлиенте
Функция ОтключениеМодуля() Экспорт

	Ванесса = Неопределено;
	
КонецФункции	 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОчиститьКаталог(Каталог)
	Если НЕ Ванесса.ФайлСуществуетКомандаСистемы(Каталог) Тогда
		Возврат;
	КонецЕсли;	 
	
	СписокКаталогов = Новый СписокЗначений;
	СписокФайлов    = Новый СписокЗначений;
	Ванесса.НайтиФайлыКомандаСистемы(Каталог, СписокКаталогов, СписокФайлов, Истина);
	
	Для Каждого Файл Из СписокФайлов Цикл
		Попытка
			Ванесса.УдалитьФайлыКомандаСистемы(Файл.Значение.ПолноеИмя);
		Исключение
		КонецПопытки;
	КонецЦикла;	
	
	СписокКаталогов = Новый СписокЗначений;
	СписокФайлов    = Новый СписокЗначений;
	Ванесса.НайтиФайлыКомандаСистемы(Каталог, СписокКаталогов, СписокФайлов, Истина);
	Для Каждого Файл Из СписокФайлов Цикл
		Попытка
			Ванесса.УдалитьФайлыКомандаСистемы(Файл.Значение.ПолноеИмя);
		Исключение
			ТекстСообщения = Ванесса.ПолучитьТекстСообщенияПользователю("Не получилось удалить файл %1");
			ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1",Файл.Значение.ПолноеИмя); 
			ВызватьИсключение ТекстСообщения;
		КонецПопытки;
	КонецЦикла;	
КонецПроцедуры 

&НаКлиенте
Функция ДанныеСкрипта(КаталогСкрипта,ОбщаяСекцияИмпорт)
	ФайлКаталогСкрипта = Новый Файл(КаталогСкрипта);
	ИмяСкрипта = ФайлКаталогСкрипта.ИмяБезРасширения;
	
	КартинкиСкрипта = Новый Массив;
	СписокКаталогов = Новый СписокЗначений;
	СписокФайлов    = Новый СписокЗначений;
	Ванесса.НайтиФайлыКомандаСистемы(КаталогСкрипта, СписокКаталогов, СписокФайлов, Ложь);
	Ванесса.ОставитьТолькоФайлыСРасширением(СписокФайлов,".png");
	
	Для Каждого Файл Из СписокФайлов Цикл
		ДанныеКартинки = Новый Структура;
		ДанныеКартинки.Вставить("ИмяФайла",Файл.Значение.Имя);
		ДанныеКартинки.Вставить("ПолноеИмя",СтрЗаменить(Файл.Значение.ПолноеИмя,"\","/"));
		КартинкиСкрипта.Добавить(ДанныеКартинки);
	КонецЦикла;	
	 
	
	ДанныеСкрипта = Новый Структура;
	
	НашлиФайл = Ложь;
	СписокКаталогов = Новый СписокЗначений;
	СписокФайлов    = Новый СписокЗначений;
	Ванесса.НайтиФайлыКомандаСистемы(КаталогСкрипта, СписокКаталогов, СписокФайлов, Ложь);
	Ванесса.ОставитьТолькоФайлыСРасширением(СписокФайлов,".py");
	
	Для Каждого Файл Из СписокФайлов Цикл
		Если НРег(Файл.Значение.ИмяБезРасширения) = НРег(ИмяСкрипта) Тогда
			НашлиФайл = Истина;
			
			ДанныеСкрипта.Вставить("ИмяСкрипта",ИмяСкрипта);	
			СекцияИмпорт = Новый Массив;
			ДанныеСкрипта.Вставить("СекцияИмпорт",СекцияИмпорт);
			ТелоСкрипта = Новый Массив;
			ДанныеСкрипта.Вставить("ТелоСкрипта",ТелоСкрипта);
			
			
			Текст = Новый ЧтениеТекста;
			Текст.Открыть(Файл.Значение.ПолноеИмя,"UTF-8");
			
			Пока Истина Цикл
				Стр = Текст.ПрочитатьСтроку();
				Если Стр = Неопределено Тогда
					Прервать;
				КонецЕсли;	 
				
				Если Лев(Стр,6) = "import" Тогда
					Стр = СокрЛП(НРег(Стр));
					Если ОбщаяСекцияИмпорт.Найти(Стр) = Неопределено Тогда
						ОбщаяСекцияИмпорт.Добавить(Стр);
						Продолжить;
					КонецЕсли;	 
				ИначеЕсли Найти(НРег(Стр),".png") > 0 Тогда
					Для Каждого КартинкаСкрипта Из КартинкиСкрипта Цикл
						Стр = СтрЗаменить(Стр,КартинкаСкрипта.ИмяФайла,КартинкаСкрипта.ПолноеИмя);
					КонецЦикла;	 
				ИначеЕсли НРег(СокрЛП(Стр)) = "exit(0)" Тогда
					//надо заменить на пустую команду
					Стр = СтрЗаменить(НРег(Стр),"exit(0)","pass");
				ИначеЕсли НРег(СокрЛП(Стр)) = "exit(1)" Тогда
					//Пока решно вызывать исключение если оно описано в скрипте
					//КолПробелов = СтрДлина(Стр) - СтрДлина(СокрЛ(Стр));
					//Стр = Лев(Стр,КолПробелов) + "CallError(""" + ИмяСкрипта + """)";
				КонецЕсли;	 
				
				Стр = СтрЗаменить(Стр,"sys.argv[1]","sys_argv_1");
				Стр = СтрЗаменить(Стр,"sys.argv[2]","sys_argv_2");
				Стр = СтрЗаменить(Стр,"sys.argv[3]","sys_argv_3");
				Стр = СтрЗаменить(Стр,"sys.argv[4]","sys_argv_4");
				Стр = СтрЗаменить(Стр,"sys.argv[5]","sys_argv_5");
				
				ТелоСкрипта.Добавить(Стр);
			КонецЦикла;	
			
			Текст.Закрыть();
			Прервать;
		КонецЕсли;	 
	КонецЦикла;	
	
	Если Не НашлиФайл Тогда
		ТекстСообщения = "Не найден файл <" + ИмяСкрипта + ".py> в каталоге <" + КаталогСкрипта + ">";
		Сообщить(ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;	 
	
	Возврат ДанныеСкрипта; 
КонецФункции

&НаКлиенте
Функция ПрочитатьФайлОтвета(ИмяФайла)
	ЧтениеJSON = Вычислить("Новый ЧтениеJSON");
	ЧтениеJSON.ОткрытьФайл(ИмяФайла);
	СтруктураПараметров = Вычислить("ПрочитатьJSON(ЧтениеJSON)");
	ЧтениеJSON.Закрыть();
	Возврат СтруктураПараметров.Response; 
КонецФункции	 

&НаКлиенте
Процедура ОпределитьАргументыСкрипта(Знач Стр,comand,sys_argv_1,sys_argv_2,sys_argv_3,sys_argv_4,sys_argv_5)
	Поз = Найти(Стр,"--args");
	Если Поз > 0 Тогда
		ЛеваяЧасть = УбратьКавычки(СокрЛП(Лев(Стр,Поз-1)));
		Стр = СокрЛП(Сред(Стр,Поз+6));
	Иначе
		Если ЗначениеЗаполнено(Стр) Тогда
			Стр = УбратьКавычки(Стр);
			Файл = Новый Файл(Стр);
			comand = Ванесса.Транслит(Файл.ИмяБезРасширения);
		КонецЕсли;	 
		
		Возврат;
	КонецЕсли;	 
	
	Файл = Новый Файл(ЛеваяЧасть);
	comand = Ванесса.Транслит(Файл.ИмяБезРасширения);
	
	НашлиПараметрВКавычках = Ложь;
	НашлиПараметр          = Ложь;
	
	НомерПараметра    = 0;
	ЗначениеПараметра = "";
	
	Для Ккк = 1 По СтрДлина(Стр) Цикл
		Символ = Сред(Стр,Ккк,1);
		
		Если Символ = """" И НЕ НашлиПараметрВКавычках Тогда
			НашлиПараметр = Истина;
			НашлиПараметрВКавычках = Истина;
			НомерПараметра = НомерПараметра + 1;
			ЗначениеПараметра = "";
			Продолжить;
		//ИначеЕсли Символ = " " И НЕ НашлиПараметрВКавычках Тогда
		//	НашлиПараметр = Истина;
		//	НашлиПараметрВКавычках = Ложь;
		//	НомерПараметра = НомерПараметра + 1;
		//	ЗначениеПараметра = "";
		//	Продолжить;
		КонецЕсли;	 
		
		Если НашлиПараметр Тогда
			Если НашлиПараметрВКавычках Тогда
				Если Символ = """" Тогда
					НашлиПараметрВКавычках = Ложь;
					НашлиПараметр          = Ложь;
					
					Если НомерПараметра = 1 Тогда
						sys_argv_1 = ЗначениеПараметра;
					ИначеЕсли НомерПараметра = 2 Тогда
						sys_argv_2 = ЗначениеПараметра;
					ИначеЕсли НомерПараметра = 3 Тогда
						sys_argv_3 = ЗначениеПараметра;
					ИначеЕсли НомерПараметра = 4 Тогда
						sys_argv_4 = ЗначениеПараметра;
					ИначеЕсли НомерПараметра = 5 Тогда
						sys_argv_5 = ЗначениеПараметра;
					КонецЕсли;	 
				Иначе	
					ЗначениеПараметра = ЗначениеПараметра + Символ;
				КонецЕсли;	 
			Иначе	
				Если Символ = " " Тогда
					НашлиПараметрВКавычках = Ложь;
					НашлиПараметр          = Ложь;
					
					Если НомерПараметра = 1 Тогда
						sys_argv_1 = ЗначениеПараметра;
					ИначеЕсли НомерПараметра = 2 Тогда
						sys_argv_2 = ЗначениеПараметра;
					ИначеЕсли НомерПараметра = 3 Тогда
						sys_argv_3 = ЗначениеПараметра;
					ИначеЕсли НомерПараметра = 4 Тогда
						sys_argv_4 = ЗначениеПараметра;
					ИначеЕсли НомерПараметра = 5 Тогда
						sys_argv_5 = ЗначениеПараметра;
					КонецЕсли;	 
				Иначе	
					ЗначениеПараметра = ЗначениеПараметра + Символ;
				КонецЕсли;	 
			КонецЕсли;	 
		КонецЕсли;	 
		
	КонецЦикла;	
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗаписатьУправляющийJson(ИмяУправляющиегоФайлаSikuliXСервер,СтрокаКоманды,comand = "")
	ВременныйJson = ПолучитьИмяВременногоФайла("json");
	
	ЗаписьJSON = Вычислить("Новый ЗаписьJSON()");
	ЗаписьJSON.ОткрытьФайл(ВременныйJson);
	
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	
	sys_argv_1 = "";
	sys_argv_2 = "";
	sys_argv_3 = "";
	sys_argv_4 = "";
	sys_argv_5 = "";
	
	ОпределитьАргументыСкрипта(СтрокаКоманды,comand,sys_argv_1,sys_argv_2,sys_argv_3,sys_argv_4,sys_argv_5);
	
	ЗаписьJSON.ЗаписатьИмяСвойства("comand");
	ЗаписьJSON.ЗаписатьЗначение(comand);
	
	ЗаписьJSON.ЗаписатьИмяСвойства("sys_argv_1");
	ЗаписьJSON.ЗаписатьЗначение(sys_argv_1);
	
	ЗаписьJSON.ЗаписатьИмяСвойства("sys_argv_2");
	ЗаписьJSON.ЗаписатьЗначение(sys_argv_2);
	
	ЗаписьJSON.ЗаписатьИмяСвойства("sys_argv_3");
	ЗаписьJSON.ЗаписатьЗначение(sys_argv_3);
	
	ЗаписьJSON.ЗаписатьИмяСвойства("sys_argv_4");
	ЗаписьJSON.ЗаписатьЗначение(sys_argv_4);
	
	ЗаписьJSON.ЗаписатьИмяСвойства("sys_argv_5");
	ЗаписьJSON.ЗаписатьЗначение(sys_argv_5);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();	
	ЗаписьJSON.Закрыть();
	
	Ванесса.ПереместитьФайлКомандаСистемы(ВременныйJson,ИмяУправляющиегоФайлаSikuliXСервер);
КонецПроцедуры 

&НаКлиенте
Функция ИмяИтогоСкрипта()
	Возврат "SikuliXServer";
КонецФункции	 

&НаКлиентеНаСервереБезКонтекста
Функция УниверсальноеПолноеИмяФайла(Знач ПолноеИмяФайлаИлиФайл, ВНРегистр = Ложь)
	ПолноеИмяФайла = ПолноеИмяФайлаИлиФайл;
	Если ТипЗнч(ПолноеИмяФайлаИлиФайл ) = Тип("Файл") Тогда
		ПолноеИмяФайла = ПолноеИмяФайлаИлиФайл.ПолноеИмя;
	КонецЕсли;

	УниверсальноеПолноеИмя = СтрЗаменить(ПолноеИмяФайла, "\", "/");
	Если ВНРегистр Тогда
		УниверсальноеПолноеИмя = НРег(УниверсальноеПолноеИмя);
	КонецЕсли;

	Возврат УниверсальноеПолноеИмя;
КонецФункции

&НаКлиенте
Функция УбратьКавычки(Знач Стр)
	Если Лев(Стр,1) = """" Тогда
		Стр = Сред(Стр,2);
	КонецЕсли;	 
	
	Если Прав(Стр,1) = """" Тогда
		Стр = Лев(Стр,СтрДлина(Стр)-1);
	КонецЕсли;	 
	
	Возврат Стр;
КонецФункции	 

&НаКлиенте
Функция ВыводКонсолиSikuliXСервер()
	Результат = "";
	ИмяФайлаВыводаКонсолиSikuliXСервер = Ванесса.ИмяФайлаВыводаКонсолиSikuliXСервер();
	Если Ванесса.ФайлСуществуетКомандаСистемы(ИмяФайлаВыводаКонсолиSikuliXСервер) Тогда
		Для Ккк = 1 По 10 Цикл
			БылаОшика = Ложь;
			
			Попытка
				Текст = Новый ЧтениеТекста;
				Текст.Открыть(ИмяФайлаВыводаКонсолиSikuliXСервер,"UTF-8",,, Ложь);
				Результат = Текст.Прочитать();
				Текст.Закрыть();
			Исключение
				БылаОшика = Истина;
				Ванесса.sleep(1);
			КонецПопытки;
			
			Если НЕ БылаОшика Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;	
		
	КонецЕсли;	 
	
	Возврат Результат; 
КонецФункции	 

#КонецОбласти
