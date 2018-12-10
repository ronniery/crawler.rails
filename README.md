# Ruby version 
  [![Ruby](https://img.shields.io/badge/ruby-2.5.3p105-yellowgreen.svg)](https://rubyinstaller.org/downloads/)  

# Status
  [![Build Status](https://travis-ci.org/ronniery/crawler.rails.svg?branch=master)](https://travis-ci.org/ronniery/crawler.rails) 
  [![Maintainability](https://api.codeclimate.com/v1/badges/b52e77b44859c59e640c/maintainability)](https://codeclimate.com/github/ronniery/crawler.rails/maintainability)
  
# Preciso iniciar o banco de dados?
  Não existe a necessidade de inicializar a base de dados pois utilizo como host de banco de dados o site [mLab](https://mlab.com/), neste site é possível
  hospedar instâncias de banco de dados mongo, portanto foram criadas 3 instâncias, *quotes*, *quotes_test* e *quotes_prod*. 

# Como executar os testes?
  Não é preciso executar os testes localmente, para desenvolver esta aplicação utilizie o servidor de integração contínua
  [Travis.CI](https://travis-ci.org), este server disponibiliza um relatório de construção do projeto que pode ser acessado aqui [Last Build](https://travis-ci.org/ronniery/crawler.rails)
  
  Mas sendo necessário executar os testes localmente execute os seguintes passos: <br>
  
  1. `git clone https://github.com/ronniery/crawler.rails.git`
  2. `cd crawler.rails`
  3. `bundle install`
  4. `rake test`
  5. `rake test:system` para testes de sistema

# Como executar a aplicação?
  Também não se faz necessário executar a aplicação localmente devido a forma que o projeto foi costruído, juntamente com o [Travis.CI](https://travis-ci.org)
  foram utilizados o servidor [Heroku](https://www.heroku.com/), o resultado da integração pode ser acessado atráves do seguinte <b>*[link](https://arcane-waters-62201.herokuapp.com/)*</b>.
  
  1. `git clone https://github.com/ronniery/crawler.rails.git`
  2. `cd crawler.rails`
  3. `bundle install`
  4. `rails server -e [production | development]` (Escolha um modo de execução do projeto)

# Qual a solução adotada na aplicação?
  Optei por criar um servidor em ruby on rails, com isso já teria um *'scaffold'* de aplicação que iria me dar agilidade, porém fiz ma péssima escolha
  de utilizar windows 10 como OS de desenvolvimento ruby, o tempo que ganhei se perdeu aqui.
  
  A aplicação possui as seguintes rotas:
  
  | Prefixo | Método | URI  | Controlador/Ação | Descrição | Seguro
  | :---: | :---: | --- | :---: | --- | :---: |
  | `root` | **GET** | [/](https://arcane-waters-62201.herokuapp.com/) | main#index | Rota base do app | ✗ |
  | `create` | **POST** | [/create](https://arcane-waters-62201.herokuapp.com/create) | main#create | Rota para criação de tokens de acesso | ✗ |
  | `quotes` | **GET** | [/quotes](https://arcane-waters-62201.herokuapp.com/quotes) | quotes#show | Rota base do controllador *quotes* | ✓ |
  | - | **GET** | /quotes/:tag | quotes#show | Exibe JSON bruto no navegador da tag informada | ✓ |
  | - | **GET** | /quotes/:tag/:mode | quotes#viewer | Exibe o JSON em um editor amigável da tag informada | ✓ |
  
  # Autenticação
  
  Representação em BPM do fluxo necessário para se obter um token:
  
  ![token_creation.png](https://github.com/ronniery/crawler.rails/blob/master/artifacts/token_creation.png)
  
  Algumas rotas vão exigir que você informe um token de acesso através do parâmetro `?t={USER_TOKEN}` ou através do header `Authorization`, 
  vejamos um exemplo:
  
  `https://arcane-waters-62201.herokuapp.com/quotes/{SEARCH_TERM}?t={USER_TOKEN}`
  
  Ou
  
  ```
    $.ajax({
      method: 'GET'
      headers: {
        'Authorization: Beaer {USER_TOKEN}
      },
      {...more options}
    })
  ```

  obs: A arquitetura da aplicação foi feita desta forma, unicamente para fins avaliativos, considerando que não existem rotas que não sejam `GET`
  onde o header com a autorização faria mais sentido.
  
  # Busca por termos
  
  
  
