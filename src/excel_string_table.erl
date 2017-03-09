%%%-------------------------------------------------------------------
%%% @author jiangxiaowei@lilith.sh
%%% @copyright (C) 2017, Lilith Games
%%% @doc
%%%
%%% @end
%%% Created : 09. 三月 2017 16:18
%%%-------------------------------------------------------------------
-module(excel_string_table).
-author("jiangxiaowei@lilith.sh").

-include("excel_reader.hrl").

%% API
-export([new/1]).

new(SharedStringXML) ->
    new(SharedStringXML, dict:new(), 0).

new([], StringTable, _Index) -> {ok, StringTable};
new([#xmlElement{content = [#xmlText{value = Value}]}|T], StringTable, Index) ->
    NewStringTable = dict:store(Index, Value, StringTable),
    new(T, NewStringTable, Index + 1).
