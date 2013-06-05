-module(anger_client).
-export([anger_client_eval/1]).
anger_client_eval(Str) ->
    {ok,Socket} = 
	gen_tcp:connect("localhost",8080,
			[binary,{packet,4}]),
    ok = gen_tcp:send(Socket,term_to_binary(Str)),
    receive
	{tcp,Socket,Bin} ->
	    io:format("Client received binary = ~p~n",[Bin]),
	    Val = binary_to_term(Bin),
	    io:format("Client result = ~p~n",[Val]),
	    gen_tcp:close(Socket)
    end.
