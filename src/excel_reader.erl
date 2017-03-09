-module(excel_reader).

%%%-------------------------------------------------------------------
%%% @author jiangxiaowei@lilith.sh
%%% @copyright (C) 2017, Lilith Games
%%% @doc
%%% 读取Excel文件
%%% @end
%%% Created : 09. 三月 2017 16:13
%%%-------------------------------------------------------------------
-author("jiangxiaowei@lilith.sh").

-include("excel_reader.hrl").

%% API exports
-export([open/1]).

%%====================================================================
%% API functions
%%====================================================================
open(File) when is_list(File) ->
    case check_extension(File) of
        true ->
            do_open(File);
        false ->
            {error, bad_excel_file}
    end;
open(_) ->
    {error, badarg}.

%%====================================================================
%% Internal functions
%%====================================================================
check_extension(File) ->
    FileExtension = filename:extension(File),
    FileExtension == ".xls" orelse FileExtension == ".xlsx".

do_open(File) ->
    {ok, ExcelData} = zip:unzip(File, [memory]),

    % prase string table info
    SharedStringsBinary = proplists:get_value("xl/sharedStrings.xml", ExcelData),
    {SharedStringsDoc, _} = xmerl_scan:string(erlang:binary_to_list(SharedStringsBinary)),
    SharedStringXML = xmerl_xpath:string("/sst/si/t", SharedStringsDoc),
    {ok, StringTable} = excel_string_table:new(SharedStringXML),

    % parse sheets info
    WorkbookBinary = proplists:get_value("xl/workbook.xml", ExcelData),
    {WorkbookDoc, _} = xmerl_scan:string(erlang:binary_to_list(WorkbookBinary)),
    [#xmlElement{content = SheetsXML}] = xmerl_xpath:string("/workbook/sheets", WorkbookDoc),
    SheetInfos = [excel_sheet:new(SheetXML)||SheetXML <- SheetsXML],

    % load sheets data
    {ok, #excel{sheets = lists:foldr(
    fun(SheetInfo = #excel_sheet{id = SheetId}, AccIn) ->
        SheetDataFile = lists:concat(["xl/worksheets/sheet", erlang:integer_to_list(SheetId), ".xml"]),
        SheetDataBinary = proplists:get_value(SheetDataFile, ExcelData),
        {SheetDataDoc, _} = xmerl_scan:string(erlang:binary_to_list(SheetDataBinary)),
        [#xmlElement{content = RowsXML}] = xmerl_xpath:string("/worksheet/sheetData", SheetDataDoc),
        Rows = [excel_row:new(RowXML, StringTable) || RowXML<-RowsXML],
        [SheetInfo#excel_sheet{rows = Rows}|AccIn]
    end, [], SheetInfos)}}.

