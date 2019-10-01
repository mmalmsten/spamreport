-module(report_handler).

-ifdef(TEST).
	-include_lib("eunit/include/eunit.hrl").
-endif.

-export([init/2]).
-export([allowed_methods/2]).
-export([content_types_provided/2]).
-export([content_types_accepted/2]).

-export([list_reports/2]).
-export([handle_report/2]).

-export([list/0]).
-export([block/1]).
-export([resolve/1]).

init(Req, Opts) ->
	{cowboy_rest, Req, Opts}.

allowed_methods(Req, State) ->
	{[<<"GET">>, <<"PUT">>], Req, State}.

content_types_provided(Req, State) ->
	{[
		{{<<"application">>, <<"json">>, []}, list_reports}
	], Req, State}.

content_types_accepted(Req, State) ->
	{[
		{{<<"application">>, <<"json">>, '*'}, handle_report}
	], Req, State}.

-spec list_reports(Req::map(), State::list()) -> 
	{Body::binary(), Req::map(), State::list()}.
list_reports(Req, State) ->
	Body = list(),
	{Body, Req, State}.

-spec handle_report(Req::map(), State::list()) -> 
	{true, Req::map(), State::list()}.
handle_report(Req, State) ->
	#{method := <<"PUT">>, bindings := #{id := Id}} = Req,
	{ok, Body, _} = cowboy_req:read_body(Req),
	case jiffy:decode(Body, [return_maps]) of 
		#{<<"ticketState">> := <<"CLOSED">>} -> resolve(Id);
		#{<<"blocked">> := true} -> block(Id)
	end,
	Resonse = list(), % Only scalable to a certain degree
	{true, cowboy_req:set_resp_body(Resonse, Req), State}.

-spec list() -> Body::binary().
list() ->
	jiffy:encode(lists:flatten(
		ets:match(report, {'_', <<"OPEN">>, '$1'})
	)).

-spec block(Id::binary()) -> true.
block(Id) ->
	[{_, Ticket_state, Element}] = ets:lookup(report, Id),
	ets:insert(report, {
		Id, Ticket_state, Element#{<<"blocked">> => true}
	}).

-spec resolve(Id::binary()) -> true.
resolve(Id) -> 
	[{_, <<"OPEN">>, Element}] = ets:lookup(report, Id),
	ets:insert(report, {
		Id, <<"CLOSED">>, Element#{<<"ticketState">> => <<"CLOSED">>}
	}).

%%----------------------------------------------------------------------
%% Unit tests
%%----------------------------------------------------------------------
-ifdef(TEST).
	list_test() ->
		report = ets:new(report, [ordered_set, named_table, public]),
		true = ets:insert(report, {123, <<"OPEN">>, #{}}),
		true = ets:insert(report, {456, <<"OPEN">>, #{}}),
		<<"[{},{}]">> = report_handler:list(),
		ets:delete(report).

	block_test() ->
		report = ets:new(report, [ordered_set, named_table, public]),
		true = ets:insert(report, {123, <<"OPEN">>, #{}}),
		true = block(123),
		[{123, <<"OPEN">>, #{<<"blocked">> := true}}] = ets:lookup(report, 123),
		ets:delete(report).

	resolve_test() ->
		report = ets:new(report, [ordered_set, named_table, public]),
		true = ets:insert(report, {123, <<"OPEN">>, #{}}),
		true = resolve(123),
		[{123, <<"CLOSED">>, #{<<"ticketState">> := <<"CLOSED">>}}] = ets:lookup(report, 123),
		ets:delete(report).
-endif.