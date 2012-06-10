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

subarray_from_bitmask(List, BitMask) -> subarray_from_bitmask_loop(List, BitMask, []).

subarray_from_bitmask_loop([],_,RevResult) -> lists:reverse(RevResult);
subarray_from_bitmask_loop(_,<<>>,RevResult) -> lists:reverse(RevResult);
subarray_from_bitmask_loop(_,<<0/bitstring>>,RevResult) -> 
  io:fwrite("empty subarray case hit"),
  lists:reverse(RevResult);
subarray_from_bitmask_loop([H|T],<<1:1,Remaining/bitstring>>,RevResult) ->
  subarray_from_bitmask_loop(T, Remaining, [H|RevResult]);
subarray_from_bitmask_loop([_|T], <<0:1,Remaining/bitstring>>,RevResult) ->
  subarray_from_bitmask_loop(T,Remaining,RevResult).

win_test_case(TestCase) -> 
  TestCaseInitialBitMask = ((1 bsl length(TestCase)) - 1),
  TestCaseLength = length(TestCase),
  win_test_case(TestCase, <<TestCaseInitialBitMask:TestCaseLength>>).

all_subcases(TestCase, BitMask, F) -> all_subcases_loop(TestCase, <<>>, BitMask, F).

all_subcases_loop(_,_,<<>>,_) -> 
  true;
all_subcases_loop(TestCase, PrefixBitMask, <<0:1, Remaining/bitstring>>, F) ->
  RemainingSize = bit_size(Remaining),
  <<Val:(RemainingSize)>> = Remaining,
  case Val of
    0 -> 
      true;
    _ -> 
      all_subcases_loop(TestCase, <<PrefixBitMask/bitstring, 0:1>>, Remaining, F)
  end;
all_subcases_loop(TestCase, PrefixBitMask, <<1:1, Remaining/bitstring>>, F) ->
  case F(<<PrefixBitMask/bitstring, 0:1, Remaining/bitstring>>) of
    true -> 
      all_subcases_loop(TestCase, <<PrefixBitMask/bitstring, 1:1>>, Remaining, F);
    false -> false
  end.
  
win_test_case(TestCase, BitMask) ->
  case almost_sorted(subarray_from_bitmask(TestCase, BitMask), true) of
  true -> true;
  false -> case all_subcases(TestCase, BitMask, fun(Bits) -> win_test_case(TestCase, Bits) end) of
    true -> false;
    false -> true
    end
  end.

get_int_from_stdin() ->
  {ok, [Data]} = io:fread("","~d"),
  Data.

is_alice(true) -> "Alice";
is_alice(false) -> "Bob".
