-module(lib_misc).
-export([pmap/2]).

pmap(F,L) ->
    S = self(),
    Ref = erlang:make_ref(),
    Pids = lists:map(fun(I) ->
		       spawn(fun() -> do_f(S,Ref,F,I) end)
	       end, L),
    gather(Pids,Ref).

do_f(Parent,Ref,F,I) ->
    Parent ! {self(),Ref,(catch F(I))}.

gather([Pid|T],Ref) ->
    receive
	{Pid,Ref,Ret} ->
	    io:format("~p,~p,~p~n",[Pid,T,Ref]),
	    %%[Ret|T]
	    [Ret|gather(T,Ref)]
    end;
gather([],_) ->
    [].
