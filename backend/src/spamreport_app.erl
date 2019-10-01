-module(spamreport_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    data_sup:start_link(), % Import (sample) data
    Dispatch = cowboy_router:compile([
        {'_', [
			{"/reports/[:id]", report_handler, []},
            {"/", cowboy_static, {priv_file, spamreport, "dist/index.html"}},
			{"/[...]", cowboy_static, {priv_dir, spamreport, "dist"}}
		]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    spamreport_sup:start_link().

stop(_State) ->
	ok.
