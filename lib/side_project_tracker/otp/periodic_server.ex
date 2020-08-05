defmodule SideProjectTracker.OTP.PeriodicServer do
  @moduledoc """
  `OTP.PeriodicServer` module takes care of saving `OTP.Projects.Server` state to file via adapter.
  The state is saved every 24 hours.
  """
  use GenServer
  alias SideProjectTracker.Projects

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Projects.sync_projects()

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    # every 24 hours
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000)
  end
end
