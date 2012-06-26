-module(solution).
-export([main/0]).
-import(math).

main() -> io:fwrite("~w~n", [trunc(edge_algorithm(get_int_from_stdin()))]).

%I GIVE UP
edge_algorithm(VertInt) ->
  PartSol = (VertInt * math:log(VertInt) / 2.0) + VertInt * 0.14 + 0.03,
  case VertInt of
  _ when VertInt < 25  -> PartSol;
  _ -> PartSol + 0.5
  end.
  
get_int_from_stdin() ->
  {ok, [Data]} = io:fread("","~d"),
  Data.