-module(solution).
-export([main/0]).
-import(lists).

main() ->
  lists:foreach(fun(Solution) -> io:fwrite("~s~n", [is_alice(Solution)]) end, get_test_cases(get_int_from_stdin())).

map_n_times(_, 0) -> [];
map_n_times(F, Times) -> [F() | map_n_times(F, Times-1)].
 
get_test_cases(NumCases) -> map_n_times(fun() -> win_test_case(get_case(get_int_from_stdin())) end, NumCases).

get_case(NumElements) -> map_n_times(fun() -> get_int_from_stdin() end, NumElements).

almost_sorted([_,_]) -> true;
almost_sorted([X,Y,Z|T]) when X > Y -> is_sorted([Y,Z|T]);
almost_sorted([X,Y,Z|T]) when X < Y, X > Z -> is_sorted([X,Y|T]);
almost_sorted([X,Y,Z|T]) when X < Y, X < Z, Y > Z -> is_sorted([X,Z|T]);
almost_sorted([X,Y,Z|T]) when X < Y, X < Z, Y < Z -> almost_sorted([Y,Z|T]).

is_sorted([_]) -> true;
is_sorted([X,Y|_]) when X > Y -> false;
is_sorted([X,Y|T]) when X < Y -> is_sorted([Y|T]).

win_test_case(TestCase) ->
  case almost_sorted(TestCase) of
    true -> true;
    false -> 
      case lists:all(fun(Element) -> win_test_case(TestCase -- [Element]) end, TestCase) of
      true -> false;
      false -> true
    end
  end.

get_int_from_stdin() ->
  {ok, [Data]} = io:fread("","~d"),
  Data.

is_alice(true) -> "Alice";
is_alice(false) -> "Bob".
