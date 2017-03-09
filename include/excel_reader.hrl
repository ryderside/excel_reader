%%%-------------------------------------------------------------------
%%% @author jiangxiaowei@lilith.sh
%%% @copyright (C) 2017, Lilith Games
%%% @doc
%%%
%%% @end
%%% Created : 09. 三月 2017 16:13
%%%-------------------------------------------------------------------
-author("jiangxiaowei@lilith.sh").

-include_lib("xmerl/include/xmerl.hrl").

%% Excel对象
-record(excel, {
    sheets = []
}).

%% 页
-record(excel_sheet, {
    id = 0,
    name,
    rows
}).

%%　行
-record(excel_row, {r, cells = []}).

%% 单元格
-record(excel_cell, {c, v}).
