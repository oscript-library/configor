# language: ru

Функционал: Формирование параметров через конструктор 
    Как разработчик
    Я хочу иметь инструмент описания параметров своего проекта для чтения из файлов
    Чтобы предоставить возможность пользователям моего проекта задавать свои параметры в формате конструктора

Контекст: Тестовый контекст
    Когда Я создаю временный каталог и сохраняю его в контекст
    И Я сохраняю значение временного каталога в переменной "КаталогПроекта"
    И Я устанавливаю рабочей каталог во временный каталог
    И Я создаю МенеджерПараметров и сохраняю его в контекст
    И Я подключаю тестовый класс описание параметров
    И Я устанавливаю АвтоНастройки с параметрами
    | .config |
    | ''     |
    | json   |

Сценарий: Чтение файла параметров согласно конструктору параметров
    Допустим Я добавляю файл ".config.json" в каталог проекта с содержанием 
    """
    {
        "version": "1.0",
        "ПараметрСтрока": "ПростоСтрока",
        "ПараметрДата": "2017-01-01T00:00:00Z",
        "ПараметрЧисло": 10,
        "ПараметрМассив": [
            "Элемент1",
            "Элемент2",
            "Элемент3"
        ],
        "ПараметрСтруктура": {
            "Строка": "ПростоСтрока",
            "Дата": "2017-01-01T00:00:00Z",
            "Число": 10,
            "Массив": [
                "Элемент1",
                "Элемент2",
                "Элемент3"
            ],
            "Структура": {
                "Строка": "ЗначениеСтруктуры",
                "Строка2": "ЗначениеСтруктуры2"
            },
            "Соответствие": {
                "КлючВнутри1": "Значение1",
                "КлючВнутри2": "Значение2"
            }
        },
        "ПараметрСоответствие": {
            "Ключ1": "Значение1",
            "Ключ2": "Значение2"
        }
    }
    """
    Когда Я выполняю чтение параметров
    Тогда Значение параметра класса "version" равно "1.0"
    И Значение параметра класса "ПараметрСтрока" равно "ПростоСтрока"
    # И Значение параметра класса "ПараметрДата" равно "2017-01-01T00:00:00Z"
    # И Значение параметра класса "ПараметрЧисло" равно "10"
    И Значение параметра класса "ПараметрСоответствие.Ключ1" равно "Значение1"
    И Значение параметра класса "ПараметрСоответствие.Ключ2" равно "Значение2"
    