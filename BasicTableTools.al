codeunit 60100 "Basic Table Tools"
{
    // 讓此 Codeunit 可以在不需要執行環境的情況下呼叫 (例如從 Web Service)
    // 但在這個簡單的案例中，可以省略此屬性。
    // CodeunitType = Normal; 
    SingleInstance = true;


    // 此函數負責清空 "Basic Table" 的所有記錄
    procedure DeleteAllBasicTableRecords()
    var
        RecRef: RecordRef;
        ConfirmDeleteAll: Boolean;
    begin
        ConfirmDeleteAll := Dialog.Confirm(
            '是否刪除所有的資料？',
            false
        );
        if ConfirmDeleteAll then begin
            // 開啟目標 Table (Basic Table)
            RecRef.Open(Database::"Basic Table");

            // 刪除 Table 中的所有記錄
            RecRef.DeleteAll();

            // 重設 RecordRef，釋放資源 (雖然非必須，但保持良好習慣)
            RecRef.Reset();

            // 顯示成功訊息
            Message('已清空 Basic Table 資料');
        end;
    end;

    // 簡單範例：呼叫 ShowTableFields(TableId) 可列出指定 Table 的每個欄位的型別與大小資訊
    // 範例用法（在介面上可用 action 或 在即時測試中呼叫）： CODEUNIT.Run(50100).ShowTableFields(18);

    procedure ShowTableFields(TableId: Integer)
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        i: Integer;
        Line: Text[1024];
        Output: Text;
    begin
        RecRef.Open(TableId);

        Output := '';

        for i := 1 to RecRef.FieldCount() do begin
            FldRef := RecRef.Field(i);
            // FieldRef 常用屬性：Number(), Name(), Type(), SubType(), Length()
            Line := Format(FldRef.Number()) + ' | ' + FldRef.Name() +
                ' | Type=' + Format(FldRef.Type()) +
                ' | SubType=N/A' +
                ' | Length=' + Format(FldRef.Length()) +
                ' | Decimals=N/A';
            Output += Line + '\n';
        end;

        // 顯示結果：開發時可改為寫入臨時表再用 page 顯示，或輸出到檔案 / telemetry
        Message('%1', Output);
    end;
}
