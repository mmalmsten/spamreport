-module(data_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
    SupFlags = #{strategy => one_for_one, intensity => 1, period => 5},
    ChildSpecs = [#{
        id => data, start => {data, start, []},
        restart => permanent, shutdown => brutal_kill,
        type => worker
    }],
    {ok, {SupFlags, ChildSpecs}}.