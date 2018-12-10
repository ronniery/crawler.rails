# Versão do ruby
  [![Ruby](https://img.shields.io/badge/ruby-2.5.3p105-yellowgreen.svg)](https://rubyinstaller.org/downloads/)  

# Condições do projeto
  [![Build Status](https://travis-ci.org/ronniery/crawler.rails.svg?branch=master)](https://travis-ci.org/ronniery/crawler.rails) 
  [![Maintainability](https://api.codeclimate.com/v1/badges/b52e77b44859c59e640c/maintainability)](https://codeclimate.com/github/ronniery/crawler.rails/maintainability)
  
# Preciso iniciar o banco de dados?
  Não existe a necessidade de inicializar a base de dados, a aplicação utiliza como host de banco de dados o site [mLab](https://mlab.com/), neste site é possível
  hospedar instâncias de banco de dados mongo, portanto foram criadas 3 instâncias, *quotes*, *quotes_test* e *quotes_prod*. 

# Como executar os testes?
  Não é preciso executar os testes localmente, para desenvolver esta aplicação utilizei o servidor de integração contínua
  [Travis.CI](https://travis-ci.org), este servidor disponibiliza um relatório de construção do projeto que pode ser acessado através do seguinte link [Last Build](https://travis-ci.org/ronniery/crawler.rails).
  
  Mas sendo necessário executar os testes localmente execute os seguintes passos: <br>
  
  1. `git clone https://github.com/ronniery/crawler.rails.git`
  2. `cd crawler.rails`
  3. `bundle install`
  4. `rake test`
  5. `rake test:system` para testes de sistema

# Como executar a aplicação?
  Também não se faz necessário executar a aplicação localmente devido a forma que o projeto foi costruído, juntamente com o [Travis.CI](https://travis-ci.org)
  foi utilizado o servidor [Heroku](https://www.heroku.com/) para hospedar a aplicação após o build, o resultado da integração pode ser acessado atráves do seguinte <b>*[link](https://arcane-waters-62201.herokuapp.com/)*</b>.
  
  Mas sendo necessário subir a aplicação localmente execute os seguintes passos:
  
  1. `git clone https://github.com/ronniery/crawler.rails.git`
  2. `cd crawler.rails`
  3. `bundle install`
  4. `rails server -e [production | development]` (Escolha um modo de execução do projeto)

# Qual a solução adotada na aplicação?
  Optei por criar um servidor em ruby on rails, com isso já teria um *'scaffold'* de aplicação que iria me dar agilidade. 
  
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
        'Authorization: Beaer {USER_TOKEN} //Não esquecer de adicionar `Bearer`
      },
      {...more options}
    })
  ```
  
   O token é válido por 2 horas.
  
  obs: A arquitetura da aplicação foi feita desta forma, unicamente para fins avaliativos, considerando que não existem rotas que não sejam `GET`
  onde o header com a autorização faria mais sentido.
  
  # Busca por termos
  
  Representação em BPM do fluxo necessário para realizar uma busca por um determinado termo:
  
  ![token_creation.png](https://github.com/ronniery/crawler.rails/blob/master/artifacts/quote_search.png)
  
  Descrição do fluxo previamente mapeado:
  
  * O controlador base `application_controller` realiza a verificação da requisição recebida por todo controlador que herda diretamente do controlador já citado e que não especifica a flag `skip_before_action :check_auth`,
  como já acontece no controlador `main_controller` verificando se a requisição possui o token de acesso, cabeçalho ou na url.
    - Se possuir o token e ele sendo válido a requisição irá ser continuada pelo controlador `quotes_controller#quotes/:tag`.
    - Ao dar continuidade a uma requisição nesta url o controlador `quote` será verificado se existe um cache salvo no banco de dados para a tag informada.
      - Se não existir uma requisição será feita a url `http://quotes.toscrape.com/tag/{SEARCH_TERM/:tag}/`.
      - Logo após receber a resposta do servidor o módulo `crawler` irá realizando o parse do html recebido, salvando cada nova quote dentro do db.
    - Se existir o controlador irá retornar a lista com todas as quotes obtidas diretamente do bd. (Indo para a última etapa do processo)
  * Conluindo a operação de parse de todo o HTML, será retornada uma lista com todas as quotes obtidas, retornando para o controlador `quotes_controller`.
  * Para finalizar o controlador `quote` retornará ao usuário o JSON com todas as quotes encontradas.

  
