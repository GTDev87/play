-module(solution).
-export([main/0]).

main() ->
  Cases = get_test_cases(get_int_from_stdin()).
%  io:write("Sequences are ~s~n", Cases).

map_n_times(F, 0) -> [];
map_n_times(F, Times) -> [F() | map_n_times(F, Times-1)].
 
get_test_cases(NumCases) ->
  map_n_times(fun() -> solve_test_case(get_case(get_int_from_stdin())) end, NumCases).

get_case(NumElements) ->
  map_n_times(fun() -> get_int_from_stdin() end, NumElements).

solve_test_case(TestCase) ->
  TestCase.

get_int_from_stdin() ->
  {ok, [Data]} = io:fread("","~d"),
  io:fwrite("var = ~w~n", [Data]),
  Data.
