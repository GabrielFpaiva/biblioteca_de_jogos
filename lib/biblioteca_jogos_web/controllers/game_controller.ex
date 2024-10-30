defmodule BibliotecaJogosWeb.GameController do
  use BibliotecaJogosWeb, :controller
  alias HTTPoison

  @rawg_api_url "https://api.rawg.io/api/games"

  def index(conn, %{"page" => page}) do
    games = fetch_games(String.to_integer(page))
    render(conn, :index, games: games, page: page)
  end

  def index(conn, _params) do
    games = fetch_games(1) # Página inicial como padrão
    render(conn, :index, games: games, page: 1)
  end

  defp fetch_games(page) do
    api_key = "18a82ba917a147abb15f38d0cea29980"
    url = "#{@rawg_api_url}?key=#{api_key}&page_size=20&page=#{page}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.get("results")
        |> Enum.map(&format_game/1)

      {:error, _reason} ->
        []
    end
  end

  defp format_game(game) do
    %{
      title: game["name"],
      description: game["description_raw"] || "Descrição não disponível",
      image_url: game["background_image"],
      genre: Enum.map(game["genres"], & &1["name"]) |> Enum.join(", "),
      age_rating: game["esrb_rating"] && game["esrb_rating"]["name"] || "Não classificado"
    }
  end
end
