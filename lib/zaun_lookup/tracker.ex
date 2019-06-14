defmodule ZaunLookup.Tracker do
  use GenServer
  import Ecto.Query, warn: false
  alias ZaunLookup.Riot
  alias ZaunLookup.Riot.Structs.{Region}
  alias ZaunLookup.Riot.Endpoints
  @regions Enum.map(Endpoints.regions(), &%Region{region: &1})

  def send_requests(regions, func) do
    Task.async_stream(regions, &func.(&1), timeout: 600_000, max_concurrency: 12)
    |> Enum.to_list()
    |> Enum.map(fn {:ok, region} -> region end)
  end

  def manage_top(regions, state) do
    if(Enum.any?(regions, &(&1.region < 100)), do: Timex.now(), else: state)
  end

  def should_update_top(state) do
    case Timex.is_valid?(state) do
      true ->
        if Timex.diff(state, Timex.now(), :hours) >= 24 do
          true
        else
          false
        end

      _ ->
        true
    end
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def subtract_requests(requests, region) do
    Map.update!(region, :requests, &(&1 - requests))
  end

  def top_region(region) do
    Riot.set_top_of_region(region)
    |> subtract_requests(region)
  end

  def top_cycle(regions) do
    # IO.puts("Top Cycle")
    # IO.inspect(regions)

    saida = send_requests(regions, &top_region/1)

    IO.puts("Saida é")
    IO.inspect(saida)
    saida
  end

  def player_region(region) do
    Riot.update_players(region)
    |> Enum.count()
    |> subtract_requests(region)
  end

  def player_cycle(regions) do
    IO.puts("Player Cycle")
    IO.inspect(regions)
    send_requests(regions, &player_region/1)
  end

  def match_region(region) do
    region
  end

  def match_cycle(regions) do
    IO.puts("Match Cycle")
    IO.inspect(regions)
    send_requests(regions, &match_region/1)
  end

  def match_list_region(region) do
    region
  end

  def match_list_cycle(regions) do
    IO.puts("Match List Cycle")
    IO.inspect(regions)
    send_requests(regions, &match_list_region/1)
  end

  def init(_state) do
    # Schedule work to be performed at some point
    schedule_work()
    {:ok, "asd"}
  end

  def handle_info(:work, state) do
    top_regions =
      if should_update_top(state) do
        # IO.puts("First if")
        top_cycle(@regions)
      else
        IO.puts("Second if")
        @regions
      end

    # IO.puts("TOPS rtegios")
    # IO.inspect(top_regions)

    state = manage_top(top_regions, state)

    top_regions
    |> player_cycle()
    |> match_cycle()
    |> match_list_cycle()

    # Do the work you desire here
    # Reschedule once more
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # In 2 minutes and change
    Process.send_after(self(), :work, 120_001)
  end
end
