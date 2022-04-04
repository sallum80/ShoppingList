defmodule ShoppingListTest do
  use ExUnit.Case

  describe "gerar_lista/2" do
    test "A função gera a lista corretamente" do
      lista_de_emails = ["teste@gmail.com", "teste2@gmail.com"]

      lista_de_compras = [
        %{
          nome: "Maca",
          qtd: 1,
          valor: 100
        }
      ]

      retorno_esperado = [
        %{email: "teste@gmail.com", valor_total: 50.0},
        %{email: "teste2@gmail.com", valor_total: 50.0}
      ]

      # Gera a lista de compras através da função gerar_lista
      lista_gerada = ShoppingList.gerar_lista(lista_de_emails, lista_de_compras)

      # Verifica se a lista_gerada é igual ao retorno esperado
      assert lista_gerada == retorno_esperado
      # Verifica se o tamanho da lista está correto
      assert length(lista_gerada) == length(lista_de_emails)

      # Pega o valor total por email
      valor_total_por_email = List.first(lista_gerada).valor_total
      # Pega o valor total da compra
      valor_compra = List.first(lista_de_compras).valor * List.first(lista_de_compras).qtd

      # Verifica se o valor total da compra foi dividido corretamente pela quantidade de email
      assert valor_total_por_email == valor_compra / length(lista_de_emails)
    end

    test "A função falha por um erro na lista inserida pelo usuário" do
      lista_de_emails = ["teste@gmail.com", "teste2@gmail.com"]

      lista_de_compras = [
        %{
          nome: "Maca",
          banana: 1,
          qtd: 100
        }
      ]

      # Espera um erro, pois a lista de compras está inválida
      assert_raise RuntimeError, "A lista de compras esta errada!", fn ->
        ShoppingList.gerar_lista(lista_de_emails, lista_de_compras)
      end
    end
  end

  describe "cria_lista_automaticamente/1" do
    test "A lista gera a lista de compras corretamente" do
      # Retorno esperado baseado no arquivo exemplo_lista_de_compras
      retorno_esperado = [
        %{nome: "maca", qtd: 1, valor: 100},
        %{nome: "pera", qtd: 1, valor: 100}
      ]

      assert ShoppingList.cria_lista_automaticamente("exemplo_lista_de_compras") ==
               retorno_esperado
    end

    test "A função dá um erro por conta do arquivo informado não existir" do
      assert_raise RuntimeError, "A lista esta incorreta!", fn ->
        ShoppingList.cria_lista_automaticamente("arquivo_inexistente")
      end
    end
  end
end
