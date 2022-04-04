defmodule ShoppingList do
  @moduledoc """
    Módulo criado para gerar a lista de compras baseado em uma lista de emails e de items.

    Cada e-mail representa uma pessoa.
    Na lista de compras, possímos as informações: Nome, Quantidade e Valor. 

    Melhorias:
    - Divisão quando o resultado é uma dízima infinita:
      * No momento, quando realizamos uma divisão que o resultado é uma dízima infinita
      temos perca de centavos. Por exemplo, ao dividirmos uma compra de total 1 real entre 3 pessoas,
      temos uma perca aprox de 1 centavo. Esse problema pode ser resolvido em uma interação futura, com
      a seguinte approach:
        ** Fazer a divisão e, caso não seja exata, tentar novamente a divisão mas 
        distribuindo 1 centavo pra 2 das 3 partes. O ideal seria simular vários cenários similares e desenvolver
        um algoritmo a partir dessa simulação. 
  """

  alias ShoppingList.Helper

  @doc """
     Essa função é responsável por gerar a lista de compras e dividir o valor total entre os emails.

     O input correto para a lista de emails é uma lista de strings. Exemplo:
     ["email1@gmail.com", "email2@gmail.com"...]

     Já o input para a lista_de_compras é uma lista de mapas seguindo
     estritamente o seguinte modelo, com a ordem: [:nome, :qtd, :valor] ex:
      [  
        %{
          nome: "Maca",
          qtd: 1,
          valor: 550
        },

        %{
          nome: "Pera",
          qtd: 2,
          valor: 250
        }
      ]

     Essa função retorna uma lista de mapas contendo o valor total da compra dividido entre os emails.

     Vale lembrar que o input da lista de compras é opcional. Como alternativa, é possível também preencher
     o arquivo "lista_de_compras" presente no projeto e apenas passar a lista_de_emails como parametro para
     essa função. Dessa forma, o programa irá automaticamente gerar a lista de compras baseada no que você
     inseriu dentro do arquivo.

     REMINDER:
       - O programa trata o valor total como INTEGER, portanto: 550 = 5.50, 250 = 2.50... Dividiremos sempre por 100
       - Se caso você for passar a lista_de_compras manualmente, fique atento a ordem das chaves no mapa, elas
       precisam estar estritamente em ordem [:nome, :qtd, :valor]
  """
  def gerar_lista(lista_de_emails, lista_de_compras \\ cria_lista_automaticamente()) do
    lista_de_compras
    |> atomify_lista
    |> checar_lista
    |> calcular_preco_item
    |> calcular_preco_total
    |> calcular_valor_total_dividido(lista_de_emails)
    |> gerar_lista_valor_com_emails(lista_de_emails)
  end

  @doc """
    Essa função gera automaticamente a lista de compras baseado no padrão aceito pelo programa
    através dos inputs colocados no arquivo "lista_de_compras"

    Raise um erro quando a lista não existe

    Melhorias:
    Melhorar o error handling se caso o usuário não seguir o padrão no arquivo
  """
  def cria_lista_automaticamente(lista \\ "lista_de_compras") do
    case File.read(lista) do
      {:ok, resultado} ->
        resultado
        # Dividindo o arquivo baseado na quebra de linha
        |> String.split("\n")
        # Mapeio o item
        |> Enum.map(fn item ->
          # Divido baseado na virgula
          # Realizo Pattern Matching no nome, qtd, valor
          [nome, qtd, valor] = String.split(item, ",")

          # Crio um mapa seguindo o padrao da funcao gerar_lista
          %{
            nome: nome,
            qtd: String.to_integer(qtd),
            valor: String.to_integer(valor)
          }
        end)

      # Raise um erro quando a lista não existe
      {:error, _reason} ->
        raise "A lista esta incorreta!"
    end
  end

  defp checar_lista(lista_de_compras) do
    Enum.map(lista_de_compras, fn item ->
      # Pega todas as chaves do mapa do item
      lista_de_chaves = Map.keys(item)

      # MELHORIA:
      # Nesse momento a validação depende da ordem das chaves. O correto seria isso dar erro
      # O erro deveria somente com a falta de uma das chaves
      if lista_de_chaves == [:nome, :qtd, :valor] do
        item
      else
        raise "A lista de compras esta errada!"
      end
    end)
  end

  # Usa o Enum.map para pegar a lista de compras, e usa a função Helper.atomify_map para transformar
  # todas as chaves do mapa de string para átomo. 
  defp atomify_lista(lista_de_compras) do
    Enum.map(lista_de_compras, fn item ->
      Helper.atomify_map(item)
    end)
  end

  # Função para calcular preço total dos itens na lista de compra 
  defp calcular_preco_item(lista_de_compras) do
    Enum.map(lista_de_compras, fn item ->
      %{item: item.nome, valor_total: item.qtd * item.valor}
    end)
  end

  # Reduz os valores em um só valor total, somando todos os valores das compras
  defp calcular_preco_total(lista_de_items) do
    Enum.reduce(lista_de_items, 0, fn item, acumulador ->
      item.valor_total + acumulador
    end)
  end

  # Divide o valor total pela quantidade de emails
  defp calcular_valor_total_dividido(valor_total, lista_de_emails),
    do: valor_total / length(lista_de_emails)

  # Transforma a lista de emails em um mapa contendo o valor total dividido entre eles e o email
  defp gerar_lista_valor_com_emails(valor_total, lista_de_emails) do
    Enum.map(lista_de_emails, fn email ->
      %{email: email, valor_total: valor_total}
    end)
  end
end
