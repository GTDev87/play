-module(solution).
-export([main/0]).

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

lazy_list_comprehension(A,F) -> lazy_list_comprehension(A,F, fun(_,_) ->  true end).
lazy_list_comprehension(A,F,G) -> lazy_list_comprehend(A,A,F,G).

lazy_list_comprehend([],_,_,_) -> [];
lazy_list_comprehend([H|T],A,F,G) -> 
  fun() ->
    case G(H,A) of
    true -> [F(H,A) | lazy_list_comprehend(T,A,F,G)];
    false -> 
      NextComp = lazy_list_comprehend(T,A,F,G),
      case T /= [] of
        true -> NextComp();
        false -> []
      end
    end
  end.

lazy_list_all(_,[]) -> true;
lazy_list_all(F, LazyList) ->
  Lazy = LazyList(),
  case Lazy /= [] of
  true -> case F(hd(LazyList())) of
    true -> lazy_list_all(F,tl(LazyList()));
    false -> false
    end;
  false -> true
  end.

subarray_from_bitmask(List, BitMask) -> subarray_from_bitmask_loop(List, BitMask, []).

subarray_from_bitmask_loop([],_,RevResult) -> lists:reverse(RevResult);
subarray_from_bitmask_loop(_,<<>>,RevResult) -> lists:reverse(RevResult);
subarray_from_bitmask_loop([H|T],<<Bit:1,Remaining/bitstring>>,RevResult) ->
  case Bit of
    1 -> subarray_from_bitmask_loop(T, Remaining, [H|RevResult]);
    0 -> subarray_from_bitmask_loop(T, Remaining, RevResult)
  end.

win_test_case(TestCase) ->
  win_test_case(TestCase, (1 bsl length(TestCase)) - 1).

win_test_case(TestCase, BitMask) ->
  TestLength = length(TestCase),
  case almost_sorted(subarray_from_bitmask(TestCase, <<BitMask:TestLength>>), true) of
  true ->
    true;
  false ->
    case lazy_list_all(
      fun(Element) -> win_test_case(TestCase, Element) end, 
      lazy_list_comprehension(
        lists:seq(0, TestLength - 1), 
        fun(Indx, _) -> BitMask bxor (1 bsl Indx) end, 
        fun(Indx, _) -> (BitMask band (1 bsl Indx)) /= 0 end)
    ) of
    true -> false;
    false -> true
    end
  end.


get_int_from_stdin() ->
  {ok, [Data]} = io:fread("","~d"),
  Data.

is_alice(true) -> "Alice";
is_alice(false) -> "Bob".

