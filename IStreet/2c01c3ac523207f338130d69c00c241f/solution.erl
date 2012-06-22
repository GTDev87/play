-module(solution).
-export([main/0]).
-import(dict).
-import(math).
-import(ets).
-record(component, {connect_two, connect_self, add_edge_self, num_connect_two, num_connect_self, num_add_edge_self}).

main() -> io:fwrite("~w~n", [solve_average_edges(get_int_from_stdin())]).

choose_two(Num) -> Num*(Num-1) bsr 1.  

solve_average_edges(NumVertices) ->
  ets:new(components, [set, named_table]),
  Solution= avg_edges_till_connected(dict:store({1, 0}, NumVertices, dict:new()), choose_two(NumVertices)),
  Solution.

avg_edges_till_connected(nil, _) -> 0;
avg_edges_till_connected(Components, NumEdges) ->
  Lookup = ets:lookup(components, Components),  
  case Lookup of
  [{_, MapValue}] -> MapValue;
  [] ->
    case (dict:size(Components) == 1) and (element(2, hd(dict:to_list(Components))) == 1) of
    true -> 
      AvgEdges = element(2, element(1, hd(dict:to_list(Components)))),
      ets:insert(components, {Components, AvgEdges}),
      AvgEdges;
    false -> 
      {_Accum, Sum} = dict:fold(fun(Tuple, Value, AccumSum) ->
        {Accum, IterSum} = AccumSum,
        Comp = new_component({Tuple, Value}),
        CompConnectSelf = Comp#component.connect_self,
        CompAddEdgeSelf = Comp#component.add_edge_self,
        CompConnectTwo = Comp#component.connect_two,
        CompNumConnectSelf = Comp#component.num_connect_self,
        CompNumAddEdgeSelf = Comp#component.num_add_edge_self,
        CompNumConnectTwo = Comp#component.num_connect_two,
        GraphWithoutComp = dict:erase(Tuple, Components),
        %io:fwrite("before connectMap~n"),
        AvgConnect = avg_edges_till_connected(combine_components(GraphWithoutComp, CompConnectSelf()), NumEdges - 1),
        ConnectSelfSum = AvgConnect  * CompNumConnectSelf(),
        %io:fwrite("after ConnectMap~n"),
        AvgAddEdgeConnect = avg_edges_till_connected(combine_components(GraphWithoutComp, CompAddEdgeSelf()), NumEdges - 1),
        AddedEdgeSum = AvgAddEdgeConnect * CompNumAddEdgeSelf(),
        %io:fwrite("after AddEdgeMap~n"),
        InterCompSum = dict:fold(fun(InterTuple, InterValue, InterAccum) ->
          InterAccumSum = InterAccum,
          InterComp = {InterTuple, InterValue},
          InterGraphWithoutComp = dict:erase(InterTuple, GraphWithoutComp),
          AvgInterEdge = avg_edges_till_connected(combine_components(InterGraphWithoutComp, CompConnectTwo(InterComp)), NumEdges - 1),
          InterSum = AvgInterEdge * CompNumConnectTwo(InterComp),
          %io:fwrite("after Double sum~n"),
          InterSum + InterAccumSum
        end, 0, Accum),
        {dict:store(Tuple, Value, Accum), IterSum + ConnectSelfSum + AddedEdgeSum + InterCompSum}
      end, {dict:new(), 0}, Components),
      case Sum of
      0 -> 
        ets:insert(components, {Components, 0}),
        0;
      _ -> 
        AvgEdges = Sum/NumEdges,
        ets:insert(components, {Components, AvgEdges}),
        AvgEdges
      end
    end
  end.
  
combine_components(_, nil) -> nil;
combine_components(Components, AddedComponents) ->
  dict:merge(fun (_Key, Val1, Val2) -> Val1 + Val2 end, Components, AddedComponents).

new_component(Tuple) ->
  #component{
    connect_two = fun(OtherTuple) ->
      NewComponent = {element(1, element(1, Tuple)) + element(1, element(1, OtherTuple)), element(2, element(1, Tuple)) + element(2, element(1, OtherTuple)) + 1}, 
      CompList = [{element(1, Tuple), element(2, Tuple) - 1}, {element(1, OtherTuple), element(2, OtherTuple) - 1}, {NewComponent, 1}],
      dict:from_list([{Key, Val} || {Key, Val} <- CompList, Val > 0])
    end,
    num_connect_two = fun(OtherTuple) ->
      element(1, element(1, Tuple)) * element(1, element(1, OtherTuple)) * element(2, Tuple) * element(2, OtherTuple)
    end,
    connect_self = fun() ->
      case element(2, Tuple) of
      1 -> nil;
      _ ->
        NewComponent = {2 * element(1, element(1, Tuple)), 2 * element(2, element(1, Tuple)) + 1},
        CompList = [{NewComponent, 1}, {element(1, Tuple), element(2, Tuple) - 2}],
        dict:from_list([{Key, Val} || {Key, Val} <- CompList, Val > 0])
      end
    end,
    num_connect_self = fun() ->
      NumVerts = (element(1, element(1, Tuple))),
      choose_two(element(2, Tuple)) * (NumVerts*NumVerts)
    end,
    add_edge_self = fun() ->
      MaxEdges = choose_two(element(1, element(1, Tuple))),
      case element(2, element(1, Tuple)) of
      MaxEdges -> nil;
      _ -> 
        NewComponent = {element(1, element(1, Tuple)), element(2, element(1, Tuple)) + 1},
        CompList = [{NewComponent, 1}, {element(1, Tuple), element(2, Tuple) - 1}],
        dict:from_list([{Key, Val} || {Key, Val} <- CompList, Val > 0])
      end
    end,
    num_add_edge_self = fun() ->
      (choose_two(element(1, element(1, Tuple))) - element(2, element(1, Tuple))) * element(2, Tuple)
    end
  }.
  
get_int_from_stdin() ->
  {ok, [Data]} = io:fread("","~d"),
  Data.