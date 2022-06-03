defmodule UserRepository do
  use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

  def init_repo() do
    GenServer.start_link __MODULE__, [], name: UserRepo
  end
  def size(pid) do
    GenServer.call pid, :size
  end
  def addUser(pid, user) do
    GenServer.cast pid, {:push, user}
  end
  def getUsers(pid) do
    GenServer.call pid, :getAll
  end
  ####
  # Genserver implementation
  def handle_call(:size, _from, stack) do
    {:reply, Enum.count(stack), stack}
  end
  def handle_call(:getAll, _from, stack) do
    {:reply, stack, stack}
  end
  def handle_cast({:push, item}, stack) do
    {:noreply, [item | stack]}
  end
end
