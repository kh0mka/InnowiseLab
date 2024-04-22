**1. Подключится к google.com, используя telnet. Выполнить следующий запрос: `GET /search?q=devops`**


Через telnet подключиться не получается и, скорее всего, не получится. Получилось только так:
```bash
curl -X GET "https://www.google.com/search?q=devops"
```

Через wget: `wget -O - "https://www.google.com/search?q=devops"` ошибка, как и через telnet:
```
--2023-08-04 12:52:31--  https://www.google.com/search?q=devops
Resolving www.google.com (www.google.com)... 142.250.203.196, 2a00:1450:401b:810::2004
Connecting to www.google.com (www.google.com)|142.250.203.196|:443... connected.
HTTP request sent, awaiting response... 403 Forbidden
2023-08-04 12:52:33 ERROR 403: Forbidden.
```


**2. Сделать CURL запрос. Записать ссылки на пользователей, полученных из ответа на запрос.**
```bash
curl -k -L -s --compressed -X GET https://api.stackexchange.com/2.3/questions/4495473/answers\?order\=desc\&sort\=activity\&site\=stackoverflow
```
1. https://stackoverflow.com/users/550510/christopher-little
2. https://stackoverflow.com/users/1195648/alessandro-vozza
3. https://stackoverflow.com/users/241877/daniel-kushner
4. https://stackoverflow.com/users/503969/greg-sansom

**3. Написать свой CURL запрос, который будет каким-либо образом взаимодействовать с API stackoverflow. Для создания запроса использовать Stack Exchange API. Сам запрос обязательно сохранить!** \

> Данный запрос будет выдавать самые плохие по репутации вопросы, сортировка по возрастанию, максимально результатов 2, сортировка по votes, сайт stackoverflow


For BASH:
```bash
curl -k -L -s --compressed -X GET https://api.stackexchange.com/2.3/questions\?order\=asc\&max\=2\&sort\=votes\&site\=stackoverflow
```
For URL:
```
https://api.stackexchange.com/2.3/questions?order=asc&max=2&sort=votes&site=stackoverflow
```

Аналогичный запрос, к примеру, с ответами: достаточно просто заменить `questions` на `answers`: 
```bash
curl -k -L -s --compressed -X GET https://api.stackexchange.com/2.3/answers\?order\=asc\&max\=2\&sort\=votes\&site\=stackoverflow
```
