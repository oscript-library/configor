# language: ru

Функционал: Чтение файла параметров через провайдер yaml 
    Как разработчик
    Я хочу иметь инструмент чтения параметров своего проекта из файлов yaml
    Чтобы предоставить возможность пользователям моего проекта задавать настройки в формате yaml

Контекст: Тестовый контекст
    Когда Я создаю временный каталог и сохраняю его в контекст
    И Я сохраняю значение временного каталога в переменной "КаталогПроекта"
    И Я устанавливаю рабочей каталог во временный каталог
    И Я создаю МенеджерПараметров и сохраняю его в контекст
    И Я устанавливаю АвтоНастройки с параметрами
    | .config |
    | ''     |
    | yaml   |

Сценарий: Чтение файла параметров в формате yaml
    Допустим Я добавляю файл ".config.yaml" в каталог проекта с содержанием 
    """
    ИмяПроекта: &app_name test-app
    
    build:
      binary: *app_name
    
    releases:
      repo:
        name: test
        owner: owner

    changelog:
      filters:
        include:
          - '^docs:'
          - '^test:'
          - Merge pull request
          - Merge branch
      sort: asc
    """
    Когда Я выполняю чтение параметров
    Тогда Значение параметра "build.binary" равно "test-app"
    И Значение параметра "releases.repo.name" равно "test"
    И Значение параметра "releases.repo.owner" равно "owner"
    И Количество значения параметра "changelog.filters.include" равно "4"

Сценарий: Подстановка значене после чтения параметров в формате yaml

   Допустим Я добавляю файл ".config.yaml" в каталог проекта с содержанием 
    """
    ИмяПроекта: &app_name test-app
    
    build:
      binary: *app_name
    
    releases:
      repo:
        name: test
        owner: owner
    replace: "test/%releases.repo.name%"
    """
    Когда Я выполняю чтение параметров
    Тогда Значение параметра "build.binary" равно "test-app"
    И Значение параметра "releases.repo.name" равно "test"
    И Значение параметра "releases.repo.owner" равно "owner"
    И Значение параметра "replace" равно "test/test"
    
Сценарий: Чтение вложенных файлов параметров yaml

   Допустим Я добавляю файл ".config.yaml" в каталог проекта с содержанием 
    """
    ИмяПроекта: &app_name test-app
    
    build:
      binary: *app_name
    
    releases:
      ReadFile: .add.yaml
    """
    И Я добавляю файл ".add.yaml" в каталог проекта с содержанием 
    """
    repo:
      name: test
      owner: owner
    """
    Когда Я выполняю чтение параметров
    Тогда Значение параметра "build.binary" равно "test-app"
    И Значение параметра "releases.repo.name" равно "test"
    И Значение параметра "releases.repo.owner" равно "owner"

