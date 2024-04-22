### Description:

---

1. Изначально определяем в модуле двух провайдеров (us-east-1, eu-west-1 с алиасами public/private_subnet)

2. Далее Data, чтобы получить провайдера для peer_region

3. Далее две Data, чтобы получить идентификатор таблицы маршрутов по умолчанию в TGW, поскольку создавать новую бессмысленно

4. Далее создаем два TGW в двух разных регионах

5. Далее необходимо сделать аттачмент TGW к каждой VPC. Public TGW для Public Subnet, Private TGW для Private Subnet

6. Далее создаем Peering TGW attachment, где указываем какой регион будет принимающим (peer_region = `accepter`). Какой TGW принимающий (peer_tgw_id = `accepter`), какой отправляющий (requester) (tgw_id = `requester`)

7. Далее необходимо со стороны accepter принять запрос на attachment peering

8. По умолчанию в таблице маршрутов стоит, что TGW RouteTable должна перенаправлять распространенным способом адрес VPC на TGW (пропускаем, добавлять не нужно)

9. Далее необходимо создать в Default TGW RouteTable маршруты:
    - [x] us-east-1 (public_subnet): должен перенаправлять трафик 172.17.0.0/16 (eu-west-1) на TGW Peering Attachment
    - [x] eu-west-1 (private_subnet): должен перенаправлять трафик 172.16.0.0/16 (us-east-1) на TGW Peering Attachment

10. Далее добавляем в RouteTable Subnets маршруты:
    - [x] Public Subnet Route Table (us-east-1): адреса 172.17.0.0/16 (eu-west-1) перенаправить на TGW ID Public (Transit Gateway in us-east-1)
    - [x] Private Subnet Route Table (eu-west-1): адреса 172.16.0.0/16 (us-east-1) перенаправить на TGW ID Private (Transit Gateway in eu-west-1)

---
