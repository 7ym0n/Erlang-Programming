-module(myfor).
-export([for/1]).

for(Max,Max,F)	-> [F(Max)];
for(I,Max,F)	-> [F(I)|for(I+1,Max,F)].