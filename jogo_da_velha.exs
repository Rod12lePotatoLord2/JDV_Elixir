defmodule JogoDaVelha do
  defstruct tabuleiro: List.duplicate(nil, 9), turno: :X

  def jogar do
    IO.puts("--- JOGO DA VELHA (FUNCIONAL) ---")
    loop_jogo(%JogoDaVelha{})
  end

  defp loop_jogo(estado) do
    desenhar_tabuleiro(estado.tabuleiro)

    cond do
      vencedor?(estado.tabuleiro, :X) -> IO.puts("🎉 Jogador X venceu!")
      vencedor?(estado.tabuleiro, :O) -> IO.puts("🎉 Jogador O venceu!")
      empate?(estado.tabuleiro)       -> IO.puts("🤝 Empate! Deu velha.")
      true ->
        posicao = obter_jogada(estado.turno, estado.tabuleiro)
        novo_tabuleiro = List.replace_at(estado.tabuleiro, posicao, estado.turno)
        proximo_turno = if estado.turno == :X, do: :O, else: :X
        
        loop_jogo(%JogoDaVelha{tabuleiro: novo_tabuleiro, turno: proximo_turno})
    end
  end

  defp desenhar_tabuleiro(tabuleiro) do
    visual = Enum.map(tabuleiro, fn 
      nil -> "."
      val -> Atom.to_string(val)
    end)

    IO.puts("\n")
    IO.puts(" #{Enum.at(visual, 0)} | #{Enum.at(visual, 1)} | #{Enum.at(visual, 2)} ")
    IO.puts("---+---+---")
    IO.puts(" #{Enum.at(visual, 3)} | #{Enum.at(visual, 4)} | #{Enum.at(visual, 5)} ")
    IO.puts("---+---+---")
    IO.puts(" #{Enum.at(visual, 6)} | #{Enum.at(visual, 7)} | #{Enum.at(visual, 8)} ")
    IO.puts("\n")
  end

  defp obter_jogada(jogador, tabuleiro) do
    input = IO.gets("Jogador #{jogador}, escolha uma posição (1-9): ")
    
    case Integer.parse(String.trim(input)) do
      {num, ""} when num in 1..9 ->
        index = num - 1
        if Enum.at(tabuleiro, index) == nil do
          index
        else
          IO.puts("❌ Posição já ocupada! Tente novamente.")
          obter_jogada(jogador, tabuleiro)
        end
      _ ->
        IO.puts("❌ Entrada inválida! Digite um número de 1 a 9.")
        obter_jogada(jogador, tabuleiro)
    end
  end

  defp vencedor?(t, j) do
    combinacoes = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ]

    Enum.any?(combinacoes, fn [a, b, c] ->
      Enum.at(t, a) == j and Enum.at(t, b) == j and Enum.at(t, c) == j
    end)
  end

  defp empate?(tabuleiro), do: not Enum.contains?(tabuleiro, nil)
end

JogoDaVelha.jogar()
