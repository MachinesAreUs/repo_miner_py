defmodule RepoMinerPy.RepoMiner do
  @moduledoc """
    GenServer used to interact with python for Git repo mining.

    ## Examples

      iex> {:ok, miner} = RepoMinerPy.RepoMiner.start_link(name: MyRepoMiner)
      {:ok, miner}
      iex> repo_url = "https://github.com/MachinesAreUs/wonderland_elixir_katas"
      "https://github.com/MachinesAreUs/wonderland_elixir_katas"
      iex> {:ok, repo_info} = GenServer.call(miner, {:analyze, repo_url: repo_url, token: nil})
      {:ok, repo_info}

      iex> {:ok, miner} = RepoMinerPy.RepoMiner.start_link(name: MyRepoMiner2)
      {:ok, miner}
      iex> repo_url = "https://github.com/MachinesAreUs/unexisting_repo"
      "https://github.com/MachinesAreUs/unexisting_repo"
      iex> {:error, error_msg} = GenServer.call(miner, {:analyze, repo_url: repo_url, token: nil})
      {:error, error_msg}
  """
  use GenServer

  def start_link(name: name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  @impl true
  def init(_) do
    :python.start_link(python: 'python3', python_path: 'lib/python')
  end

  @impl true
  def handle_call({:analyze, repo_url: url, token: token}, _from, python_pid) do
    result = :python.call(python_pid, :repo_miner, :analyze, [url, token])
    {:reply, result, python_pid}
  end
end
