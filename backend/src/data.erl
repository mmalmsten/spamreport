-module(data).

-ifdef(TEST).
	-include_lib("eunit/include/eunit.hrl").
-endif.

-export([start/0]).
-export([init/0]).

-spec start() -> {ok, Pid::pid()}.
start() ->
    ets:new(report, [ordered_set, named_table, public]),
    Pid = spawn(?MODULE, init, []), {ok, Pid}.

-spec init() -> ok.
init() -> 
    {ok, Data} = file:read_file([
        code:priv_dir(spamreport), "/reports.json"
    ]),
    #{<<"elements">> := Elements} = jiffy:decode(Data, [return_maps]),
    lists:foreach(fun(Element) -> 
        #{<<"id">> := Id, <<"state">> := State} = Element,
        ets:insert(report, {Id, State, Element})
    end, Elements).