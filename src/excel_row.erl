%%%-------------------------------------------------------------------
%%% @author jiangxiaowei@lilith.sh
%%% @copyright (C) 2017, Lilith Games
%%% @doc
%%%
%%% @end
%%% Created : 09. 三月 2017 16:27
%%%-------------------------------------------------------------------
-module(excel_row).
-author("jiangxiaowei@lilith.sh").

-include("excel_reader.hrl").

%% API
-export([new/2]).

new(#xmlElement{attributes = Attrs, content = CellsXML}, StringTable) ->
    {value, #xmlAttribute{value = R}} = lists:keysearch(r, #xmlAttribute.name, Attrs),
    Cells = [excel_cell:new(CellXML, StringTable)|| CellXML <- CellsXML],
    #excel_row{r = list_to_integer(R), cells = Cells}.
