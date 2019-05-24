defmodule ZaunLookup.Tracker do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{},opts)
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    IO.puts("Works?")
    # Do the work you desire here
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    IO.puts("Schedule")
    Process.send_after(self(), :work, 10000) # In 2 hours
  end
end
