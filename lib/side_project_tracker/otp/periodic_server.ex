defmodule SideProjectTracker.OTP.PeriodicServer do
  @moduledoc """
  `PeriodicServer` module takes care of saving `ProjectServer` state to file via adapter.
  The state is saved every 5 minutes.
  """
  use GenServer
  alias SideProjectTracker.OTP.{ProjectServer, StorageAdapter}
  import SideProjectTracker.OTP.ServerNaming, only: [name: 2]

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    StorageAdapter.list_projects()
    |> Enum.each(fn project ->
      :server
      |> name(project)
      |> ProjectServer.get()
      |> StorageAdapter.save()
    end)

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    # every 5 minutes
    Process.send_after(self(), :work, 5 * 60 * 1000)
  end
end
