# ShoppingList
# Criado por Fábio Sallum

### Como usar:
- `git clone`
- `iex -S mix `
- `mix test` para rodar os testes da aplicação 
- ATENÇÃO: Não deletar o arquivo `exemplo_lista_de_compras`

### Como gerar a lista:
- Para gerar a lista basta utilizar a função `ShoppingList.gerar_lista/2`
- A função leva em conta dois argumentos `lista_de_emails` e `lista_de_compras`. Para mais informações consulte a documentação da função.

### Como o app funciona:
- A Aplicação realiza a leitura da lista de compras e de emails e realiza a soma dos valores e divide pela quantidade de e-mails.
- A aplicação realiza a leitura de duas listas. Uma lista de compras que possui: nome, quantidade e valor. Enquanto a outra lista são e-mails representando pessoas.
- Após realizar a leitura, checamos a lista para verificar se os valores dos parâmetros da lista de compras está correto. Após realizar essa verificação, somamos todos os valores da lista de compras e dividimos pela quantidade total de e-mail.
- Por fim, geramos uma lista contendo o valor total da lista dividido pelo os e-mails. Representando o quanto cada pessoa tem que pagar pela compra.

### Como gerar a lista de compras baseado em um arquivo:
- Se preferir, é possível gerar a lista_de_compras baseado em um arquivo. Para isso, altere o arquivo `lista_de_compras` presente neste repositório
- Basta inserir o nome_do_item,quantidade,valor
- Lembrando que a aplicação trata o valor como INTEIRO. Portanto: 1,00 = 100
- Você pode encontrar um exemplo de como utilizar o arquivo, no `exemplo_lista_de_compras`
- Após preencher o arquivo utilize a função: `ShoppingList.gerar_lista/1` para gerar a lista.