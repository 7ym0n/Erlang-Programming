-module(anger).
-export([start_anger_server/0]).

start_anger_server()->
    {ok,Listen} = gen_tcp:listen(8080,[binary,{packet,4},
				       {reuseaddr,true},
				       {active,true}]),
    spawn(fun() -> par_connect(Listen) end).
   %% {ok,Socket} = gen_tcp:accept(Listen),
   %% gen_tcp:close(Listen),
   %% loop(Socket).

par_connect(Listen) ->
    {ok,Socket} = gen_tcp:accept(Listen),
    spawn(fun() -> par_connect(Listen) end),
    loop(Socket).

loop(Socket) ->
    receive
	{tcp,Socket,Bin} ->
	    io:format("Server received binary = ~p~n",[Bin]),
	    Str = binary_to_term(Bin),
	    io:format("Server (unpacked) ~p~n",[Str]),
	    Reply = Str,
	    io:format("Server replying = ~p~n",[Reply]),
	    gen_tcp:send(Socket,term_to_binary(Reply)),
	    loop(Socket);
	{tcp_closed,Socket} ->
	    io:format("Server socket closed ~n")
    end.
