defmodule SideProjectTracker.OTP.PeriodicServer do
  @moduledoc """
  `PeriodicServer` module takes care of saving `ProjectServer` state to file via adapter.
  The state is saved every 5 minutes.
  """
  use GenServer
  alias SideProjectTracker.OTP.{ProjectServer, StorageAdapter}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    ProjectServer.get()
    |> StorageAdapter.save()

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    # every 5 minutes
    Process.send_after(self(), :work, 5 * 60 * 1000)
  end
end
