#использовать "../"
#Использовать asserts
#Использовать logos
#Использовать tempfiles
#Использовать json

Перем юТест;
Перем Лог;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;

	ИменаТестов = Новый Массив;

	ИменаТестов.Добавить("ТестДолжен_ПроверитьПолучениеПараметровИзИндекса");
	ИменаТестов.Добавить("ТестДолжен_ПроверитьВыгрузкуПараметровВКласс");
	ИменаТестов.Добавить("ТестДолжен_ПроверитьПоискИЧтениеФайлаПараметров");
	// ИменаТестов.Добавить("ТестДолжен_ПроверитьПарсингОпций");
	// ИменаТестов.Добавить("ТестДолжен_ПроверитьПарсингМассивовОпций");

	Возврат ИменаТестов;

КонецФункции

Процедура ТестДолжен_ПроверитьПолучениеПараметровИзИндекса() Экспорт

	ТестовыеСлучаи = Новый Массив;
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("{ ""version"": ""1.0"" }", "version", "1.0"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("{ ""version"": 1.0,
	|	""values"": 
	|		{ ""import"": ""тест"" }
	|
	|}", "values.import", "тест"));

	ТестовыеСлучаи.Добавить(ТестовыйСлучай("{ ""version"": 1.0,
	|	""values"": [
	|		{ ""import"": ""тестмассива0"" },
	|		{ ""import"": ""тестмассива1"" }
	|
	|		]
	|
	|}", "values.0.import values.1.import", "тестмассива0 тестмассива1"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("{ ""version"": 1.0,
	|	""values"": [
	|		{ ""import"": ""тестмассива0"" },
	|		{ ""test"": ""тестмассива1"" }
	|		]
	|}", "values.0.import values.1.test", "тестмассива0 тестмассива1"));
	

	МенеджерПараметров = Новый МенеджерПараметров;

	Для каждого Тест Из ТестовыеСлучаи Цикл

		ТестовыйФайл = ПодготовитьТестовыйФайл(Тест.ТекстФайлаПроверки);
		МенеджерПараметров.УстановитьФайлПараметров(ТестовыйФайл);
		МенеджерПараметров.Прочитать();

		Для ИндексПараметра = 0 По Тест.ИменаПараметров.ВГраница() Цикл
			
			ЗначениеПараметра = МенеджерПараметров.Параметр(Тест.ИменаПараметров[ИндексПараметра]);
			Утверждения.ПроверитьРавенство(ЗначениеПараметра, Тест.Результаты[ИндексПараметра], СтрШаблон("Результат должен совпадать с ожиданиями. Для текста <%1>", Тест.ТекстФайлаПроверки));

		КонецЦикла;

		УдалитьФайлы(ТестовыйФайл);

	КонецЦикла

КонецПроцедуры

Процедура ТестДолжен_ПроверитьВыгрузкуПараметровВКласс() Экспорт
	
	МенеджерПараметров = Новый МенеджерПараметров();
	СтруктураПараметров = Новый Структура("version, ПараметрСтрока, ПараметрЧисло, ПараметрМассив, ПараметрСтруктура, ПараметрСоответствие", 
		"1.0",
		"ПростоСтрока", 
		10, 
		ПолучитьНовыйМассив("Элемент1, Элемент2, Элемент3"),
		Новый Структура("Строка, Число, Массив, Структура, Соответствие", 
			"ПростоСтрока", 
			10, 
			ПолучитьНовыйМассив("Элемент1, Элемент2, Элемент3"),
			Новый Структура("Строка, Строка2", "ЗначениеСтруктуры", "ЗначениеСтруктуры2"),
			ПолучитьСоответствие("КлючВнутри1, КлючВнутри2", "Значение1, Значение2")
			), 
		ПолучитьСоответствие("Ключ1, Ключ2", "Значение1, Значение2")
	);

	ПарсерJSON = Новый ПарсерJSON;
	ТекстФайлаПроверки = ПарсерJSON.ЗаписатьJSON(СтруктураПараметров);


	КлассПараметров = ПодготовитьТестовыйКласс(СтруктураПараметров);

	ТестовыйФайл = ПодготовитьТестовыйФайл(ТекстФайлаПроверки);
	МенеджерПараметров.УстановитьФайлПараметров(ТестовыйФайл);
	МенеджерПараметров.УстановитьКлассПриемник(КлассПараметров);
	МенеджерПараметров.Прочитать();

	ПроверочнаяСтруктура = КлассПараметров.ПолучитьВнутренниеПараметры();
	ТекстПроверки = ПарсерJSON.ЗаписатьJSON(ПроверочнаяСтруктура);

	Утверждения.ПроверитьРавенство(ТекстФайлаПроверки, ТекстПроверки, "Результат должен совпадать с ожиданиями.");

КонецПроцедуры

Процедура ТестДолжен_ПроверитьПоискИЧтениеФайлаПараметров() Экспорт

	МенеджерПараметров = Новый МенеджерПараметров();
	СтруктураПараметров = Новый Структура("version, ПараметрСтрока, ПараметрЧисло, ПараметрМассив, ПараметрСтруктура, ПараметрСоответствие", 
		"1.0",
		"ПростоСтрока", 
		10, 
		ПолучитьНовыйМассив("Элемент1, Элемент2, Элемент3"),
		Новый Структура("Строка, Число, Массив, Структура, Соответствие", 
			"ПростоСтрока", 
			10, 
			ПолучитьНовыйМассив("Элемент1, Элемент2, Элемент3"),
			Новый Структура("Строка, Строка2", "ЗначениеСтруктуры", "ЗначениеСтруктуры2"),
			ПолучитьСоответствие("КлючВнутри1, КлючВнутри2", "Значение1, Значение2")
			), 
		ПолучитьСоответствие("Ключ1, Ключ2", "Значение1, Значение2")
	);

	ПарсерJSON = Новый ПарсерJSON;
	ТекстФайлаПроверки = ПарсерJSON.ЗаписатьJSON(СтруктураПараметров);

	ТестовыйФайл = ПодготовитьТестовыйФайл(ТекстФайлаПроверки);

	ТестовоеИмя = "config";
	ТестовоеРасширение = ".json";

	ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();
	КопироватьФайл(ТестовыйФайл, ОбъединитьПути(ВременныйКаталог, ТестовоеИмя + ТестовоеРасширение));

	МенеджерПараметров.УстановитьИмяФайла(ТестовоеИмя);
	МенеджерПараметров.ДобавитьКаталогПоиска(ВременныйКаталог);

	МенеджерПараметров.Прочитать();

	Утверждения.ПроверитьРавенство(СтруктураПараметров.ПараметрМассив[0], МенеджерПараметров.Параметр("ПараметрМассив.0"), "Результат должен совпадать с ожиданиями.");
	Утверждения.ПроверитьРавенство(СтруктураПараметров.ПараметрСтруктура.Массив[0], МенеджерПараметров.Параметр("ПараметрСтруктура.Массив.0"), "Результат должен совпадать с ожиданиями.");
	Утверждения.ПроверитьРавенство(СтруктураПараметров.ПараметрСтруктура.Соответствие["КлючВнутри1"], МенеджерПараметров.Параметр("ПараметрСтруктура.Соответствие.КлючВнутри1"), "Результат должен совпадать с ожиданиями.");
	
	ВременныеФайлы.Удалить();

КонецПроцедуры

Функция ПолучитьНовыйМассив(ЗначенияМассив)

	Массив = Новый Массив();

	МассивЗначений = СтрРазделить(ЗначенияМассив, ", ");

	Для ИндексКлюча = 0 По МассивЗначений.ВГраница() Цикл
		
		Массив.Добавить(МассивЗначений[ИндексКлюча]);

	КонецЦикла;

	Возврат Массив;

КонецФункции

Функция ПолучитьСоответствие(Ключи, Значения)

	Соответствие = Новый Соответствие();

	МассивКлючей = СтрРазделить(Ключи, ", ");
	МассивЗначений = СтрРазделить(Значения, ", ");

	Для ИндексКлюча = 0 По МассивКлючей.ВГраница() Цикл
		
		Соответствие.Вставить(МассивКлючей[ИндексКлюча], МассивЗначений[ИндексКлюча]);

	КонецЦикла;

	Возврат Соответствие;

КонецФункции

Функция ПодготовитьТестовыйКласс(ОбщиеПараметры)

	ТекстМодуляКласса = "
	|
	|//Перем ОбщиеПараметры; // Передается контекстом при создании класса
	|Перем ВнутренниеПараметры;
	|
	|Функция ПолучитьПараметры() Экспорт
	|	Возврат ОбщиеПараметры;
	|КонецФункции
	|
	|Функция ПолучитьВнутренниеПараметры() Экспорт
	|	Возврат ВнутренниеПараметры;
	|КонецФункции
	|
	|Процедура УстановитьПараметры(НовыеПараметры)Экспорт
	|	ВнутренниеПараметры = НовыеПараметры;
	|КонецПроцедуры
	|
	|Процедура ПриУстановкиЗначенияПараметра(Знач ПолныйПутьКлюча, Знач ИмяКлюча, Значение, СтандартнаяОбработка) Экспорт
	|	//Сообщить(""Попал >> ПриУстановкиЗначенияПараметра для параметра: "" + ПолныйПутьКлюча);
	|КонецПроцедуры
	|";

	Возврат ЗагрузитьСценарийИзСтроки(ТекстМодуляКласса, Новый Структура("ОбщиеПараметры", ОбщиеПараметры));

КонецФункции

Функция ПодготовитьТестовыйФайл(Знач ТестФайла)

	ТестовыйФайл = ВременныеФайлы.НовоеИмяФайла("json");
	
	ЗаписьТекста = Новый ЗаписьТекста;
	ЗаписьТекста.Открыть(ТестовыйФайл);
	ЗаписьТекста.ЗаписатьСтроку(ТестФайла);
	ЗаписьТекста.Закрыть();

	Возврат ТестовыйФайл;

КонецФункции

Функция ТестовыйСлучай(Знач ТекстФайлаПроверки, Знач ИменаПараметров, Знач Результаты)

	Тест = Новый Структура;
	Тест.Вставить("ТекстФайлаПроверки", ТекстФайлаПроверки);
	Тест.Вставить("ИменаПараметров", СтрРазделить(ИменаПараметров, " "));
	Тест.Вставить("Результаты", СтрРазделить(Результаты, " "));

	Возврат Тест;

КонецФункции

Функция ТестовыйСлучайПоиска(Знач ТекстФайлаПроверки, Знач ИменаПараметров, Знач Результаты)

	Тест = Новый Структура;
	Тест.Вставить("КаталогПоиска", ТекстФайлаПроверки);
	Тест.Вставить("ИменаПараметров", СтрРазделить(ИменаПараметров, " "));
	Тест.Вставить("Результаты", СтрРазделить(Результаты, " "));

	Возврат Тест;

КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.lib.configor");
Лог.УстановитьУровень(УровниЛога.Отладка);

ЛогПровайдера = Логирование.ПолучитьЛог("oscript.lib.configor.provider-json");
ЛогПровайдера.УстановитьУровень(УровниЛога.Отладка);