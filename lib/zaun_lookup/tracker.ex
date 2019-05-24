defmodule ZaunLookup.Tracker do
  use GenServer
  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def init(state) do
    # Schedule work to be performed at some point
    ZaunLookup.Riot.set_tops_of_regions()
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    IO.puts("Works?")
    # Do the work you desire here
    # Reschedule once more

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    IO.puts("Schedule")
    # In 2 hours
    Process.send_after(self(), :work, 120300 )
  end
end
