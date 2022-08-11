# search.avy.ru

## <a name="general"></a> Общие шаги
Вне зависимости от конфигурации вам нужно выполнить следующие  
шаги:
1. Создать папки 
  + `web-sites/search.avy/mariadb/data` (для файлов таблиц БД)
  + `web-sites/search.avy/mariadb/logs` (для логов СУБД)
  + `web-sites/search.avy/elasticsearch/data` (данные Elasticsearch)
  + `web-sites/search.avy/elasticsearch/logs` (логи Elasticsearch)
Эти папки потом будут заполнены автоматически
3. Переименуйте `web-sites/search.avy/.env.example` в `.env`
4. Поменяйте необходимые параметры этом .env (`GID` и `UID`  
успользуйте такой же как и в `.env` apache контейнера)
5. Далее вам нужно загрузить все файлы сайта в папку  
`web-sites/search.avy/htdocs`. Корень сайта в файлах проекта  
указвыайте как `/var/www/html`. Сервер базы данных указывайте  
как `avy-search-mysql`. Параметры подключения такие же как в `.env`

## <a name="dev"></a> Development сборка
1. Для установки dev билда поставьте значение `ENV=dev` в `.env` 
файле
2. Запустите команду `docker-compose build` из папки `web-sites/avy`
3. Далее `docker-compose up -d` чтобы запустить сборку 

## <a name="prod"></a> Production сборка
1. Для установки dev билда поставьте значение `ENV=prod` в `.env`
   файле
2. Запустите команду `docker-compose build` из папки `web-sites/avy`
3. Далее `docker-compose up -d` чтобы запустить сборку 