defmodule ZaunLookup.Tracker do
  use GenServer
  import Ecto.Query, warn: false
  alias ZaunLookup.Riot
  alias ZaunLookup.Riot.Endpoints
  @regions Enum.map(Endpoints.regions(), &%{region: &1, requests: 100})
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
    Task.async_stream(regions, &top_region(&1), timeout: 600_000, max_concurrency: 12)
    |> Enum.to_list()
  end

  def player_region(region) do
    Riot.update_players(region)
    |> Enum.count()
    |> subtract_requests(region)
  end

  def player_cycle(regions) do
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
    IO.puts("Player Cycle")

    @regions
    |> top_cycle()
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
