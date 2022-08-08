# avy - development kit

## TODO:
1. Прописать в инструкциях `mkdir` для монтируемых папок,  
чтобы их владельцем не был root
2. Автоматическое продления ssl сертификатов
3. Прописать всю документацию

## Что это за репозиторий?
В этом репозитории находится серверное окружение для сайта `avy`  
и его сервисов. Обновление окружение происходит примерно в одно время  
вместе с выходом новых версии сайта и сервисов (для более точной  
справки ориентируйтесь на время коммитов). Окружение полностью  
написно на `docker` и может быть быстро развернуто на любом VDS.  
Все инструкции представлены ниже.  

## Предисловие
Любое даже незначительное изменение в одном с конфигурационном  
файлах (неважно будет это конфиг `apache httpd` или `mysql`  
или вообще один из `dockre-compose.yml`)  
может привести к ошибкам или неожиданным последствиям, так как  
контейнеры и композиции тесно связаны между собой.  
Так что если вы не очень знакомы с `Docker` и `Linux`,  
лучше просто следуйте инструкциям.

## Содержание

1. [Схема](#scheme)
2. [Общая установка](#general-installation)
3. [avy.ru][] 
   + [development сборка][]
   + [production сборка][]
4. [search.avy.ru]
   + [development сборка][]
   + [production сборка][]

## <a name="scheme"></a> Схема
В корне репозитория есть Apache httpd, который запускает php  
или же отдает статику из папок сайтов (`/web-sites/*`). Сами  
настройки php, базы данных и т.д. лежат непосредственно в папках  
(`/web-sites/avy.ru` и `/web-sites/search.avy.ru`). Тоесть  
для каждого сайта работают отдельные контейнеры с php и БД.  
Стоит отметить, что `volumes` и конфиги контейнера с apache  
связаны с содержимым в папках сайтов, а также настройкой их  
`docker-compose.yml`, `Dockerfile` и т.д. Общая схема выглядит  
примерно так:
````
    apache и certbot
            |
            |___ web-sites/avy.ru (конфиги для php и БД,  
                 а также контент сайта)
            |
            |___ web-sites/search.avy.ru (конфиги для php, БД,  
                 а также контент сайта)
````

## <a name="general-installation"></a> Общая установка
1. Как уже было сказано выше, сервер состоит из Docker композиций,  
Поэтому первым делом вам нужно поставить терминальные утилиты  
`docker` и `docker-compose`.  
2. Далее вам нужно создать следующие директории:
````
certbot/conf/
certbot/logs/
certbot/www/
````
3. Далее вам нужно переименовать все `.env.example` файлы в `.env`  
(также не забудьте поменять все пароли в этих файлах).
4. Выбрать `UID` и `GID` в `.env` файлах. Это параметры id  
пользователя и группы в unix системах. Рекомендуется просто  
выбрать одинаковые значения во всех `.env` файлах, чтобы они сов- 
падали с этими же параметрами на хост-машине. Это нужно, чтобы  
файлы которые были сгенерированы внутри контейнера были  
доступны без прав суперпользователя, а также могли открываться и  
изменяться в разных контейнерах. 
5. Далее нужно указать `ENV` переменные в `.env` файлах. Для  
корневого `.env` это означает, что при `ENV=dev` сайты будут откры-  
ваться только локально по адресам `avy.loc` и `search.avy.loc`  
(не забудьте добавить эти параметры в ваш `hosts` файл) и по  
протоколу http. А при `ENV=prod` по `avy.ru` и `search.avy.ru` и    
протокол только https.

Далее будут рассмотрены более детальные принципы установки для  
каждого сайта

1. [avy.ru][]
   + [development сборка][]
   + [production сборка][]
2. [search.avy.ru][]
   + [development сборка][]
   + [production сборка][]

[avy.ru]: docs/avy.ru.md
[development сборка]: docs/avy.ru.md#dev
[production сборка]: docs/avy.ru.md#prod
[search.avy.ru]: docs/search.avy.ru.md
[development сборка]: docs/search.avy.ru.md#dev
[production сборка]: docs/search.avy.ru.md#prod