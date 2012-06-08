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

almost_sorted([_,_], true) -> true;
almost_sorted([_], false) -> true;
almost_sorted([H|T], true) ->
  %need to delete Head
  %io:fwrite("true ~w~w~n", [H, T]),
  ThirdIndx = lists:nth(2,T),
  case H > hd(T) of
    true -> almost_sorted(T, false);
    false -> case H > ThirdIndx of
      true -> almost_sorted([H,hd(T)|lists:nthtail(2,T)], false);
      false -> case hd(T) > ThirdIndx of
        true -> almost_sorted([H|tl(T)], false);
        false -> almost_sorted(T, true)
      end
    end
  end;

almost_sorted([H|T], false) ->
  %io:fwrite("false ~w~w~n", [H,T]),
  case H > hd(T) of
    true -> false;
    false -> almost_sorted(T, false)
  end.

win_test_case(TestCase) ->
  case almost_sorted(TestCase, true) of
    true ->
      %io:fwrite("sorted bitches ~n"),
      true;
    false -> 
      %io:fwrite("not sorted cont ~n"),
      case lists:all(fun(Element) -> win_test_case(Element) end, [lists:delete(Element, TestCase) || Element <- TestCase]) of
      true -> false;
      false -> true
    end
  end.


get_int_from_stdin() ->
  {ok, [Data]} = io:fread("","~d"),
  Data.

is_alice(true) -> "Alice";
is_alice(false) -> "Bob".

