codeunit 60100 "Basic Table Cleaner"
{
    trigger OnRun()
    var
        myTable: Record "Basic Table";
    begin
        if Confirm('確定要刪除 %1 中的所有資料？', false, myTable.TableCaption) then begin
            myTable.DeleteAll();
            myTable.Reset();
            Message('已刪除所有資料。');
        end;
    end;
}
