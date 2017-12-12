
Перем СтрокаАнализа;
Перем Токены;

Перем ОшибкаЧтения;
Перем ПодробноеОписаниеОшибки;

Процедура ПриСозданииОбъекта(Знач ВходящаяСтрока)

	СтрокаАнализа = ВходящаяСтрока;
	
	Токены = Новый Массив;
	ОшибкаЧтения = "";
	
	ПодробноеОписаниеОшибки = Новый Структура;

КонецПроцедуры

Функция Прочитать() Экспорт
	
	Токены.Очистить();
	
	ПрочитатьТокены();

	Возврат ЭтотОБъект;

КонецФункции

Функция ПолучитьТокены() Экспорт

	Если ЕстьОшибка() Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат Токены;

КонецФункции

Процедура ВывестиИнформациюОбОшибке() Экспорт

	Сообщить("Ошибка разбора строки: " + ОшибкаЧтения);
	
КонецПроцедуры

Функция ЕстьОшибка() Экспорт
	Возврат Не ПустаяСтрока(ОшибкаЧтения);	
КонецФункции

Процедура ПрочитатьТокены()
	Токены.Очистить();

	Чтение = Новый ЧтениеСтроки(СтрокаАнализа);
	
	Пока Чтение.Читать() Цикл
		
		ТекущийСимвол = Чтение.ТекущийСимвол();
		ТекущийИндекс = Чтение.ТекущийИндекс();

		Если Чтение.ЭтоСимвол(" ") 
			ИЛИ Чтение.ЭтоСимвол(Символы.ПС) Тогда
			Продолжить
		ИначеЕсли Чтение.ЭтоСимвол("[") Тогда
			Токены.Добавить(НовыйТокен(ТипыТокенов().TTOpenSq, ТекущийСимвол, ТекущийИндекс));
		ИначеЕсли Чтение.ЭтоСимвол("]") Тогда
			Токены.Добавить(НовыйТокен(ТипыТокенов().TTCloseSq, ТекущийСимвол, ТекущийИндекс));
		ИначеЕсли Чтение.ЭтоСимвол("(") Тогда
			Токены.Добавить(НовыйТокен(ТипыТокенов().TTOpenPar, ТекущийСимвол, ТекущийИндекс));
		ИначеЕсли Чтение.ЭтоСимвол(")") Тогда
			Токены.Добавить(НовыйТокен(ТипыТокенов().TTClosePar, ТекущийСимвол, ТекущийИндекс));
		ИначеЕсли Чтение.ЭтоСимвол("|") Тогда
			Токены.Добавить(НовыйТокен(ТипыТокенов().TTChoice, ТекущийСимвол, ТекущийИндекс));
		ИначеЕсли Чтение.ЭтоСимвол(".") Тогда
			
			НачальныйИндекс = ТекущийИндекс;

			Троеточие = Чтение.ВСтроку(ТекущийИндекс, ТекущийИндекс+3);

			Если Не Троеточие = "..." Тогда
				ОшибкаЧтения = "Ошибка в строке Спек, неправильно использованы символы <...>, должно быть 3";
				Прервать;
			КонецЕсли;				
			Токены.Добавить(НовыйТокен(ТипыТокенов().TTRep, Троеточие, ТекущийИндекс));
			Чтение.ЧитатьНа(2);

		ИначеЕсли Чтение.ЭтоСимвол("-") Тогда
			
			СтартоваяПозиция = ТекущийИндекс;

			Если Не Чтение.Читать() Тогда
				ОшибкаЧтения = "Ошибка в строке Спек, не указано имя опции";
				Прервать;
			КонецЕсли;

			СледующийСимвол = Чтение.ТекущийСимвол();
			
			Если Чтение.ЭтоБуква() Тогда

				Чтение.ЧитатьДо("ПродолжитьЧтение = ЭтоБуква();");

				ТипТокена = ТипыТокенов().TTShortOpt;
				НазваниеТокена = Чтение.ВСтроку(СтартоваяПозиция, Чтение.ТекущийИндекс());
				
				Если СтрДлина(НазваниеТокена) > 2 Тогда
					ТипТокена = ТипыТокенов().TTOptSeq;
					НазваниеТокена = Сред(НазваниеТокена, 1);
				КонецЕсли;
				
				Токены.Добавить(НовыйТокен(ТипТокена, НазваниеТокена, СтартоваяПозиция));

				Если НЕ Чтение.КонецСтроки() 
					И Чтение.ВЧтениеСтрокиС(Чтение.ТекущийИндекс() + 1).ЭтоСимвол("-") Тогда
					ОшибкаЧтения = "Не правильный синтаксис. Короткой опции";
					Прервать;
				КонецЕсли;
							
			ИначеЕсли Чтение.ЭтоСимвол("-") Тогда
			
				Если Чтение.КонецСтроки()
					ИЛИ Чтение.СледующийСимволЭто(" ") Тогда
					Токены.Добавить(НовыйТокен(ТипыТокенов().TTDoubleDash, "--", СтартоваяПозиция));
					Продолжить;
				КонецЕсли;

				Чтение.ЧитатьДо("ПродолжитьЧтение = ЭтоБуква() ИЛИ ЭтоЧисло() ИЛИ ЭтоСимвол(""_"") ИЛИ ЭтоСимвол(""-"");");

				НазваниеТокена = Чтение.ВСтроку(СтартоваяПозиция, Чтение.ТекущийИндекс());

				Если СтрДлина(НазваниеТокена) = 2 Тогда
					ОшибкаЧтения = "Не правильный синтаксис. Короткой опции";
					Прервать;
				КонецЕсли;

				Токены.Добавить(НовыйТокен(ТипыТокенов().TTLongOpt, НазваниеТокена, СтартоваяПозиция))

			КонецЕсли;

		ИначеЕсли Чтение.ЭтоСимвол("=") Тогда
			
			СтартоваяПозиция = ТекущийИндекс;
			
			Если Не Чтение.СледующийСимволЭто("<") Тогда
				ОшибкаЧтения = "Отсутствует начало описания опции '=<'";
				Прервать;
			КонецЕсли;

			Закрыто = Чтение.ЧитатьДоСимвола(">");

			Если Не Закрыто Тогда
				ОшибкаЧтения = "Не закрытое описание опции";
				Прервать;
			КонецЕсли;

			Если Чтение.ТекущийИндекс() - СтартоваяПозиция = 2 Тогда
				ОшибкаЧтения = "Отсутствует описание опции";
				Прервать;
			КонецЕсли;
			
			Чтение.Читать();

			НазваниеТокена = Чтение.ВСтроку(СтартоваяПозиция, Чтение.ТекущийИндекс());
			Токены.Добавить(НовыйТокен(ТипыТокенов().TTOptValue, НазваниеТокена, СтартоваяПозиция));
		Иначе
			Если Чтение.ЭтоБольшаяБуква() Тогда
			
				СтартоваяПозиция = ТекущийИндекс;
		
				Чтение.ЧитатьДо("ПродолжитьЧтение = ЭтоБольшаяБуква() ИЛИ ЭтоЧисло() ИЛИ ЭтоСимвол(""_"");");

				НазваниеТокена = Чтение.ВСтроку(СтартоваяПозиция, Чтение.ТекущийИндекс());

				ТипТокена = ТипыТокенов().TTArg;

				Если НазваниеТокена = "OPTIONS" Тогда
					ТипТокена = ТипыТокенов().TTOptions;
				КонецЕсли;
				
				Токены.Добавить(НовыйТокен(ТипТокена, НазваниеТокена, СтартоваяПозиция))
			Иначе
				ОшибкаЧтения = СтрШаблон("Неизвестная ошибка! Индекс в строке: %1, символ: %2 ", Чтение.ТекущийИндекс(), Чтение.ТекущийСимвол());
				Прервать;
			КонецЕсли;
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры


Функция ТипыТокенов() Экспорт
	Типы = Новый Структура;
	Типы.Вставить("TTArg", "Arg");
	Типы.Вставить("TTOpenPar", "OpenPar");
	Типы.Вставить("TTClosePar", "ClosePar");
	Типы.Вставить("TTOpenSq", "TTOpenSq");
	Типы.Вставить("TTCloseSq", "CloseSq");
	Типы.Вставить("TTChoice", "Choice");
	Типы.Вставить("TTOptions", "Options");
	Типы.Вставить("TTRep", "Rep");
	Типы.Вставить("TTShortOpt", "ShortOpt");
	Типы.Вставить("TTLongOpt", "LongOpt");
	Типы.Вставить("TTOptSeq", "OptSeq");
	Типы.Вставить("TTOptValue", "OptValue");
	Типы.Вставить("TTDoubleDash", "DblDash");
	
	Возврат Типы;
КонецФункции

Функция НовыйТокен(ТипТокена, Значение, Позиция) 
	Возврат Новый Структура("Тип, Значение, Позиция", ТипТокена, Значение, Позиция);
КонецФункции	