# LuizaLabs - Desafio técnico - Vertical Logística

## O desafio
- Temos uma demanda para integrar dois sistemas. O sistema legado que possui um arquivo de pedidos desnormalizado, precisamos transformá-lo em um arquivo json normalizado. E para isso precisamos satisfazer alguns requisitos.

- Faça um sistema que receba um arquivo via API REST e processe-o para ser retornado via API REST.

## Informações técnicas
**Gems utilizadas:**
- Rails 8
- Sidekiq
- ActiveModelSerializers
- Kaminari
- Redis
- RSpec
- Rubocop
- Simplecov
- Faker
- FactoryBot
- dotenv

**Banco de dados:**
- sqlite3

**Conteinerização**
- Docker
- DockerHub

**Deploy**
  - AWS Lightsail

**Padrões utilizados:**
- **ServiceObjects**
    - Usados para organizar a lógica de negócios fora dos modelos e controladores. Ajudam a manter o código limpo e fácil de manter, encapsulando funcionalidades específicas em classes dedicadas

- **QueryObjects**
    - Usados para encapsular consultas complexas e específicas de banco de dados, mantendo os modelos e controladores mais limpos. Ajudam a organizar e reutilizar lógica de consulta, tornando o código mais legível e fácil de testar

- **SOLID Principles**
  - Single Responsibility
  - Open/Closed
  - Dependency Inversion

### Workflow  

![image](https://github.com/user-attachments/assets/366f2803-74f1-4496-ae2c-4f904f57e70e)

## Implementação

Foi desenvolvida uma API REST para receber arquivos, processar e listar os pedidos.

A API possui os seguintes endpoints:

- Importa e processa o arquivo de pedidos em background
    - ```POST /api/v1/files/import```
- Retorna os pedidos no formato JSON
    - ```GET /api/v1/users```

Através da API também é possível filtrar pelo ID do pedido:  
```
GET /api/v1/users?order_id=153
```

E paginar os pedidos:
```
GET /api/v1/users?page=1&per_page=5
```

#### Fluxo de importação
Os pedidos são importados da seguinte forma:
1. O upload do arquivo é feito para o diretório `/tmp`
2. Um background job executa o serviço `ImportFileJob` que contém toda a lógica de processamento
3. Os pedidos são armazenados no banco de dados

## Como testar

O deploy já foi feito no AWS Lightsail e está disponível através de um IP público.
Podemos utilizar o `curl` para fazer os testes:

- Importar/Processar arquivo de pedidos
```
curl -X POST -F "file=@/~/Desktop/orders.txt" http://34.205.71.232/api/v1/files/import
```

- Listar pedidos no formato JSON
```
curl -X GET http://34.205.71.232/api/v1/users
```

## Testes
Os testes foram escritos com rspec e a análise da cobertura com SimpleCov

[![CI](https://github.com/guilhermemellonascimento/magalu/actions/workflows/ci.yml/badge.svg)](https://github.com/guilhermemellonascimento/magalu/actions/workflows/ci.yml)

```
bundle exec rspec
```
