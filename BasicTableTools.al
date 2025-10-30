codeunit 60100 "Basic Table Tools"
{
    // 讓此 Codeunit 可以在不需要執行環境的情況下呼叫 (例如從 Web Service)
    // 但在這個簡單的案例中，可以省略此屬性。
    // CodeunitType = Normal; 



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
}
