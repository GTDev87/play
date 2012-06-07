-module(solution).
-export([main/0]).
-import(lists).

main() ->
  lists:foreach(fun(Solution) -> io:fwrite("~s~n", [is_alice(Solution)]) end, get_test_cases(get_int_from_stdin())).

map_n_times(_, 0) -> [];
map_n_times(F, Times) -> [F() | map_n_times(F, Times-1)].
 
get_test_cases(NumCases) ->
  map_n_times(fun() -> win_test_case(get_case(get_int_from_stdin())) end, NumCases).

get_case(NumElements) ->
  map_n_times(fun() -> get_int_from_stdin() end, NumElements).

is_sorted([_]) -> true;
is_sorted([H|T]) ->
  case H > hd(T) of
    true -> false;
    false -> is_sorted(T)
  end.

win_test_case(TestCase) ->
  NextCases = [lists:delete(Element, TestCase) || Element <- TestCase],
  case lists:any(fun(Element) -> is_sorted(Element) end, NextCases) of
    true -> true;
    false -> case lists:all(fun(Element) -> win_test_case(Element) end, NextCases) of
      true -> false;
      false -> true
      end
  end.


get_int_from_stdin() ->
  {ok, [Data]} = io:fread("","~d"),
  Data.

is_alice(true) -> "Alice";
is_alice(false) -> "Bob".

