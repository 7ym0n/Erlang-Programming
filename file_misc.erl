-module(file_misc).
-include("file.hrl").
-export([consult/1,file_size_and_type/1]).

consult(File) ->
    case file:open(File,read) of
	{ok,S} ->
	    Val = consult1(S),
	    file:close(S),
	    {ok,Val};
	{error,Why} ->
	    {error,Why}
    end.

consult1(S) ->
    case io:read(S,'') of
	{ok,Term} ->
	    [Term|consult1(S)];
	eof -> [];
	Error -> Error
    end.



file_size_and_type(File) ->
    case file:read_file_info(File) of
	{ok,Facts} ->
	    {Facts#file_info.type,Facts#file_info.size};
	_ -> error
    end.
