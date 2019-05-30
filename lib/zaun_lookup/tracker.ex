defmodule ZaunLookup.Tracker do
  use GenServer
  import Ecto.Query, warn: false
  alias ZaunLookup.Riot
  alias ZaunLookup.Riot.Endpoints
  @regions Enum.map(Endpoints.regions(), &%{region: &1, requests: 100})

  def manage_top(regions, state) do
    if(Enum.any?(regions, &(&1[:requests] < 100)), do: Timex.now(), else: state)
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
    IO.puts("Top Cycle")
    IO.inspect(regions)

    Task.async_stream(regions, &top_region(&1), timeout: 600_000, max_concurrency: 12)
    |> Enum.to_list()
  end

  def player_region(region) do
    Riot.update_players(region)
    |> Enum.count()
    |> subtract_requests(region)
  end

  def player_cycle(regions) do
    IO.puts("Player Cycle")
    IO.inspect(regions)

    Task.async_stream(regions, &player_region(&1),
      timeout: 600_000,
      max_concurrency: 12
    )
    |> Enum.to_list()
  end

  def init(state) do
    # Schedule work to be performed at some point
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    top_regions =
      if should_update_top(state) do
        top_cycle(@regions)
      else
        @regions
      end

    state = manage_top(top_regions, state)

    top_regions
    |> player_cycle()

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
