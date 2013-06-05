-module(test_mnesia).
-export([demo/1]).
-record(shop,{item,quantity,cost).
-record(cost,{name,price}).

demo(select_shop) ->
    
    do(qlc:q([X || X <- mnesia:table(shop)]));
demo(reorder) ->
    do(qlc:q([X#shop.item || X <- mnesia:table(shop),
			     X#shop.quantity < 250]));
demo(join) -> 
    do(qlc:q([X:shop.item || X <- mnesia:table(shop),
			    X#shop.quantity < 250,
			    Y <- mnesia:table(cost),
			    Y#shop.item =:= Y#cost.name,
			    Y#cost.price < 2]).


add_shop_item(Name,Quantity,Cost) ->
    Row = #shop{item=Name,quantity = Quantity,cost = Cost},
    F = fun() ->
		mnesia:write(Row)
	end,
    mnesia:transaction(F).
