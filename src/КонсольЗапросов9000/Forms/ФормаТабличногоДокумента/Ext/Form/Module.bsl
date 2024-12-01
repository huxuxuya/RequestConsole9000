﻿
&НаСервере
Функция ПолучитьРазмерыКолонок(тзРазмерыДанных)
	
	чМинимальныйРазмерКолонки = 8;
	чОтброс = 1.0;//%
	маРазмерыКолонок = Новый Массив;
	Для Каждого Колонка Из тзРазмерыДанных.Колонки Цикл
		
		тз1к = тзРазмерыДанных.Скопировать(, Колонка.Имя);
		тз1к.Сортировать(Колонка.Имя + " Убыв");
		
		Если тз1к.Количество() > 0 Тогда
			маРазмерыКолонок.Добавить(Макс(тз1к[Цел(тз1к.Количество() * чОтброс / 100)][0], чМинимальныйРазмерКолонки));
		Иначе
			маРазмерыКолонок.Добавить(чМинимальныйРазмерКолонки);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат маРазмерыКолонок;
	
КонецФункции

&НаСервере
Процедура ВывестиВетку(Документ, СтрокаВывода, СтрокаВыводаГруппировка1, СтрокаВыводаГруппировка2, Выборка, тзРазмерыПолей, Обработка, фЕстьМакроколонки, стМакроколонки)
	
	Пока Выборка.Следующий() Цикл
		
		ВыборкаПодчиненные = Выборка.Выбрать();
		фГруппировка = ВыборкаПодчиненные.Количество() > 0;
		
		Если фГруппировка Тогда
			
			Если Выборка.Уровень() = 0 Тогда
				
				СтрокаВыводаГруппировка1.Параметры.Заполнить(Выборка);
				Если фЕстьМакроколонки Тогда
					Обработка.ОбработатьМакроколонки(СтрокаВыводаГруппировка1.Параметры, Выборка, стМакроколонки);
				КонецЕсли;
				
			    Документ.Вывести(СтрокаВыводаГруппировка1, Выборка.Уровень());
				
			Иначе
				
				СтрокаВыводаГруппировка2.Параметры.Заполнить(Выборка);
				Если фЕстьМакроколонки Тогда
					Обработка.ОбработатьМакроколонки(СтрокаВыводаГруппировка2.Параметры, Выборка, стМакроколонки);
				КонецЕсли;
				
			    Документ.Вывести(СтрокаВыводаГруппировка2, Выборка.Уровень());
				
			КонецЕсли;
			
		Иначе
			
			СтрокаВывода.Параметры.Заполнить(Выборка);
			Если фЕстьМакроколонки Тогда
				Обработка.ОбработатьМакроколонки(СтрокаВывода.Параметры, Выборка, стМакроколонки);
			КонецЕсли;
			
		    Документ.Вывести(СтрокаВывода, Выборка.Уровень());
			
		КонецЕсли;
		
		СтрокаДлин = тзРазмерыПолей.Добавить();
		Для Каждого Колонка Из тзРазмерыПолей.Колонки Цикл
			СтрокаДлин[Колонка.Имя] = СтрДлина(СтрокаВывода.Параметры[Колонка.Имя]);
		КонецЦикла;
		
		Если фГруппировка Тогда
			ВывестиВетку(Документ, СтрокаВывода, СтрокаВыводаГруппировка1, СтрокаВыводаГруппировка2, ВыборкаПодчиненные, тзРазмерыПолей, Обработка, фЕстьМакроколонки, стМакроколонки);
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДокумент(Параметры)
	
	Обработка = РеквизитФормыВЗначение("Объект");
	
	стРезультатЗапроса = ПолучитьИзВременногоХранилища(Параметры.АдресРезультатаЗапроса);
	маРезультатЗапроса = стРезультатЗапроса.Результат;
	стРезультатПакета = маРезультатЗапроса[Число(Параметры.РезультатВПакете) - 1];
	рзВыборка = стРезультатПакета.Результат;
	ИмяРезультата = стРезультатПакета.ИмяРезультата;
	стМакроколонки = стРезультатПакета.Макроколонки;
	ЕстьМакроколонки = стМакроколонки.Количество() > 0;
	
	Документ.Очистить();
	
	ЛинияОтчета = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	ЦветЛинииШапки = ЦветаСтиля.ЦветЛинииОтчета;
	ШрифтЗаголовка = Новый Шрифт("Arial", 12, Истина);
	ШрифтПодзаголовка = Новый Шрифт("Arial", 8, Истина);
	//ШрифтШапки = ШрифтыСтиля.шрифтшНовый Шрифт(, 8, Ложь);
	ЦветШапки = ЦветаСтиля.ЦветФонаШапкиТаблицы;
	
    чЗаголовкиКолонок = Новый Структура;
    СтрокаВывода = Документ.ПолучитьОбласть(1, 1, 1, рзВыборка.Колонки.Количество());
    СтрокаВыводаГруппировка1 = Документ.ПолучитьОбласть(1, 1, 1, рзВыборка.Колонки.Количество());
    СтрокаВыводаГруппировка2 = Документ.ПолучитьОбласть(1, 1, 1, рзВыборка.Колонки.Количество());
    СтрокаШапки = Документ.ПолучитьОбласть(1, 1, 1, рзВыборка.Колонки.Количество());
    СтрокаПустая = Документ.ПолучитьОбласть(1, 1, 1, рзВыборка.Колонки.Количество());
	Для й = 1 по рзВыборка.Колонки.Количество() Цикл
		
		Колонка = рзВыборка.Колонки[й - 1];
        ИмяКолонки = Колонка.Имя;
		
		//строка данных
        ОбластьЗаполнения = СтрокаВывода.Область(1, й, 1, й);
        ОбластьЗаполнения.Параметр = ИмяКолонки;
        ОбластьЗаполнения.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр;
		ОбластьЗаполнения.ГраницаСверху = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСнизу = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСлева = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСправа = ЛинияОтчета;
		//ОбластьЗаполнения.АвтоОтступ = 4;
		
		//заголовок группировки 1
        ОбластьЗаполнения = СтрокаВыводаГруппировка1.Область(1, й, 1, й);
		ОбластьЗаполнения.ЦветФона = ЦветаСтиля.ЦветФонаГруппировкиОтчета1;
        ОбластьЗаполнения.Параметр = ИмяКолонки;
        ОбластьЗаполнения.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр;
		ОбластьЗаполнения.ГраницаСверху = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСнизу = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСлева = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСправа = ЛинияОтчета;
		//ОбластьЗаполнения.АвтоОтступ = 4;
		
		//заголовок группировки 2
        ОбластьЗаполнения = СтрокаВыводаГруппировка2.Область(1, й, 1, й);
		ОбластьЗаполнения.ЦветФона = ЦветаСтиля.ЦветФонаГруппировкиОтчета2;
        ОбластьЗаполнения.Параметр = ИмяКолонки;
        ОбластьЗаполнения.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр;
		ОбластьЗаполнения.ГраницаСверху = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСнизу = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСлева = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСправа = ЛинияОтчета;
		//ОбластьЗаполнения.АвтоОтступ = 4;
		
		//шапка
        ОбластьЗаполнения = СтрокаШапки.Область(1, й, 1, й);
		//ОбластьЗаполнения.Шрифт = ШрифтШапки;
		ОбластьЗаполнения.ГраницаСверху = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСнизу = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСлева = ЛинияОтчета;
		ОбластьЗаполнения.ГраницаСправа = ЛинияОтчета;
		ОбластьЗаполнения.ЦветФона = ЦветШапки;
        ОбластьЗаполнения.Параметр = ИмяКолонки;
		ОбластьЗаполнения.ГоризонтальноеПоложение = ГоризонтальноеПоложение.ПоШирине;
		//ОбластьЗаполнения.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		ОбластьЗаполнения.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
        ОбластьЗаполнения.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр;
		ОбластьЗаполнения.Примечание.Текст = Колонка.ТипЗначения;
		
        чЗаголовкиКолонок.Вставить(ИмяКолонки, ИмяКолонки);
		
	КонецЦикла;
	
    СтрокаЗаголовка = Документ.ПолучитьОбласть(1, 1);
	ОбластьЗаголовка = СтрокаЗаголовка.Область(1, 1, 1, 1);
	ОбластьЗаголовка.Текст = Параметры.ИмяЗапроса;
	ОбластьЗаголовка.Шрифт = ШрифтЗаголовка;
    Документ.Вывести(СтрокаЗаголовка);
	ОбластьЗаголовка.Текст = ИмяРезультата;
	ОбластьЗаголовка.Шрифт = ШрифтПодзаголовка;
	ОбластьЗаголовка.Отступ = 4;
    Документ.Вывести(СтрокаЗаголовка);
	Документ.Вывести(СтрокаПустая);
    СтрокаШапки.Параметры.Заполнить(чЗаголовкиКолонок);
    Документ.Вывести(СтрокаШапки);
	
	тзРазмерыДанных = Новый ТаблицаЗначений;
	Для Каждого кз Из чЗаголовкиКолонок Цикл
		ИмяКолонки = кз.Ключ;
		тзРазмерыДанных.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(5, 0)));
	КонецЦикла;
	
	Если Параметры.ВидРезультата = "таблица" Тогда
		
		выбВыборка = рзВыборка.Выбрать();
		Пока выбВыборка.Следующий() Цикл
			
	        СтрокаВывода.Параметры.Заполнить(выбВыборка);
			Если ЕстьМакроколонки Тогда
				Обработка.ОбработатьМакроколонки(СтрокаВывода.Параметры, выбВыборка, стМакроколонки);
			КонецЕсли;
			
	        Документ.Вывести(СтрокаВывода);
			
			СтрокаДлин = тзРазмерыДанных.Добавить();
			Если ЕстьМакроколонки Тогда
				Для Каждого Колонка Из тзРазмерыДанных.Колонки Цикл
					СтрокаДлин[Колонка.Имя] = СтрДлина(СтрокаВывода.Параметры[Колонка.Имя]);
				КонецЦикла;
			Иначе
				Для й = 0 По тзРазмерыДанных.Колонки.Количество() - 1 Цикл
					СтрокаДлин[й] = СтрДлина(выбВыборка[й]);
				КонецЦикла;
			КонецЕсли;
		
		КонецЦикла;	
		
		маРазмерыКолонок = ПолучитьРазмерыКолонок(тзРазмерыДанных);
		
		Для й = 0 По маРазмерыКолонок.Количество() - 1 Цикл
			Документ.Область(1, й + 1, Документ.ВысотаТаблицы, й + 1).ШиринаКолонки = маРазмерыКолонок[й];
		КонецЦикла;
		
	ИначеЕсли Параметры.ВидРезультата = "дерево" Тогда
		
		Документ.НачатьАвтогруппировкуСтрок();
		
		чСчетчик = 0;
		выбВыборка = рзВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ВывестиВетку(Документ, СтрокаВывода, СтрокаВыводаГруппировка1, СтрокаВыводаГруппировка1, выбВыборка, тзРазмерыДанных, Обработка, ЕстьМакроколонки, стМакроколонки);
		
		Документ.ЗакончитьАвтогруппировкуСтрок();
		
		маРазмерыКолонок = ПолучитьРазмерыКолонок(тзРазмерыДанных);
		
		Для й = 0 По маРазмерыКолонок.Количество() - 1 Цикл
			Документ.Область(1, й + 1, Документ.ВысотаТаблицы, й + 1).ШиринаКолонки = маРазмерыКолонок[й];
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры
	
&НаСервере
Процедура ОбновитьДокументНаСервере(Параметры)
	
	КопироватьДанныеФормы(Параметры.Объект, Объект);
	
	Заголовок = СтрШаблон("%1 / Результат%2", Параметры.ИмяЗапроса, Параметры.РезультатВПакете - 1);
	
	Элементы.ГруппаДерево.Видимость = Параметры.ВидРезультата = "дерево";
	
	СформироватьДокумент(Параметры);
	
	Инициализированна = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	Инициализированна = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьДокументНаСервере(Параметры);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Обновить" Тогда
		ОбновитьДокументНаСервере(Параметр);
	КонецЕсли;
КонецПроцедуры
