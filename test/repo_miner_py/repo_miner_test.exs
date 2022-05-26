defmodule RepoMinerTest do
  use ExUnit.Case, async: true
  doctest RepoMinerPy.RepoMiner

  test "Singleton miner starts up with application and works" do
    repo_url = "https://github.com/MachinesAreUs/libgraph"

    assert {:ok,
            %{
              num_commits: _,
              user_commits_histogram: %{},
              monthly_commits_histogram: %{}
            }} = GenServer.call(MyMiner, {:analyze, repo_url: repo_url, token: nil})
  end
end
