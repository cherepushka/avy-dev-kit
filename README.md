# avy - development kit

## TODO:
1. Прописать в инструкциях `mkdir` для монтируемых папок,  
чтобы их владельцем не был root
2. Прописать bash скрипты для генерации `letsencrypt` сертификатов  
и также генерации сертификатов для localhost
3. Автоматическое продления ssl сертификатов

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