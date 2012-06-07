-module(solution).
-export([main/0]).

main() ->
  Cases = get_test_cases(get_int_from_stdin()).
%  io:write("Sequences are ~s~n", Cases).

map_n_times(F, 0) -> [];
map_n_times(F, Times) -> [F() | map_n_times(F, Times-1)].
 
get_test_cases(NumCases) ->
  map_n_times(fun() -> win_test_case(get_case(get_int_from_stdin())) end, NumCases).

get_case(NumElements) ->
  map_n_times(fun() -> get_int_from_stdin() end, NumElements).

is_sorted(Array) ->
  case list:sort(Array) == Array of
    true -> true;
    false -> false
  end.
  

win_test_case(TestCase) ->
  NextCases = [list:delete(Element, TestCase) || Element <- TestCase],

  case list:any(fun(Element) -> is_sorted(Element) end, NextCases) of
    true -> true;
    false -> case list:all(fun(Element) -> win_test_case(Element) == false end, NextCases) of
      true -> false;
      false -> true
      end
  end.


get_int_from_stdin() ->
  {ok, [Data]} = io:fread("","~d"),
  io:fwrite("var = ~w~n", [Data]),
  Data.
