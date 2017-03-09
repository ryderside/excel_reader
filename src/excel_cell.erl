%%%-------------------------------------------------------------------
%%% @author jiangxiaowei@lilith.sh
%%% @copyright (C) 2017, Lilith Games
%%% @doc
%%%
%%% @end
%%% Created : 09. 三月 2017 16:47
%%%-------------------------------------------------------------------
-module(excel_cell).
-author("jiangxiaowei@lilith.sh").

-include("excel_reader.hrl").

%% API
-export([new/2]).

new(#xmlElement{attributes = Attrs, content = [#xmlElement{content = [#xmlText{value = V}]}]}, StringTable) ->
    {value, #xmlAttribute{value = C}} = lists:keysearch(r, #xmlAttribute.name, Attrs),
    case lists:keysearch(t, #xmlAttribute.name, Attrs) of
        false ->
            #excel_cell{c = C, v = V};
        {value, #xmlAttribute{value = _}} ->
            #excel_cell{c = C, v = dict:fetch(list_to_integer(V), StringTable)}
    end.

