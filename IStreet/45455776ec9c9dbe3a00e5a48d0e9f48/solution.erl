-module(solution).
-export([main/0]).
-import(dict).

main() ->
  foreach(fun(Solution) -> io:fwrite("~s~n", [is_alice(Solution)]) end, get_test_cases(get_int_from_stdin())).

foreach(_, []) -> ok;
foreach(F, [H|T]) ->
  F(H),
  foreach(F,T).

map_n_times(_, 0) -> [];
map_n_times(F, Times) -> [F() | map_n_times(F, Times-1)].
 
get_test_cases(NumCases) ->
  map_n_times(fun() -> win_test_case(get_case(get_int_from_stdin())) end, NumCases).

get_case(NumElements) ->
  map_n_times(fun() -> get_int_from_stdin() end, NumElements).

almost_sorted([_,_], true) -> true;
almost_sorted([_], false) -> true;
almost_sorted([A,B,C|T], true) ->
  case A > B of
    true -> almost_sorted([B,C|T], false);
    false -> case A > C of
      true -> almost_sorted([A,B|T], false);
      false -> case B > C of
        true -> almost_sorted([A,C|T], false);
        false -> almost_sorted([B,C|T], true)
      end
    end
  end;

almost_sorted([H|T], false) ->
  case H > hd(T) of
    true -> false;
    false -> almost_sorted(T, false)
  end.

lazy_list_comprehension([],_,_) -> [];
lazy_list_comprehension([H|T],A,F) -> fun() -> [F(H,A) | lazy_list_comprehension(T,A,F)] end.

lazy_list_all(_,[]) -> true;
lazy_list_all(F, LazyList) ->
  case F(hd(LazyList())) of
    true -> lazy_list_all(F,tl(LazyList()));
    false -> false
  end.

win_test_case(TestCase) ->
  case almost_sorted(TestCase, true) of
    true ->
      true;
    false ->
      case lazy_list_all(fun(Element) -> win_test_case(Element) end, lazy_list_comprehension(TestCase, TestCase, fun(Ele, Array) -> Array -- [Ele] end)) of
      true -> false;
      false -> true
    end
  end.


get_int_from_stdin() ->
  {ok, [Data]} = io:fread("","~d"),
  Data.

is_alice(true) -> "Alice";
is_alice(false) -> "Bob".

