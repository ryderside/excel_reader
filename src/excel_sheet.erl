%%%-------------------------------------------------------------------
%%% @author jiangxiaowei@lilith.sh
%%% @copyright (C) 2017, Lilith Games
%%% @doc
%%%
%%% @end
%%% Created : 09. 三月 2017 16:17
%%%-------------------------------------------------------------------
-module(excel_sheet).
-author("jiangxiaowei@lilith.sh").

-include("excel_reader.hrl").

%% API
-export([new/1]).

new(#xmlElement{attributes = Attrs}) ->
    {value, #xmlAttribute{value = SheetName}} = lists:keysearch(name, #xmlAttribute.name, Attrs),
    {value, #xmlAttribute{value = SheetId}} = lists:keysearch(sheetId, #xmlAttribute.name, Attrs),
    #excel_sheet{id = list_to_integer(SheetId), name = SheetName}.

