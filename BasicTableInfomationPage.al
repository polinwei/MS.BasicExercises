page 60102 "Table Field Explorer"
{
    Caption = 'Table Field Explorer';
    PageType = List;
    ApplicationArea = All;
    SourceTable = Field; // 使用虛擬表 "Field" (2000000041)

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("TableNo"; Rec."TableNo") { ApplicationArea = All; }
                field("Table Name"; Rec.TableName) { ApplicationArea = All; Caption = 'Table Name'; }
                field("Field No."; Rec."No.") { ApplicationArea = All; Caption = 'Field No.'; }
                field("Field Name"; Rec.FieldName) { ApplicationArea = All; Caption = 'Field Name'; }
                field("Data Type"; Rec."Type") { ApplicationArea = All; Caption = 'Data Type'; }
                //field("Length"; Rec."Length") { ApplicationArea = All;}
                field("Class"; Rec.Class) { ApplicationArea = All; Caption = 'Class'; }
            }
        }
    }
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        i: Integer;
        Line: Text[1024];
        Output: Text;

    trigger OnAfterGetRecord()
    begin
        RecRef.Open(70800); // Field table ID
        Output := '';

        // 用 FIELDINDEX 根據順序存取欄位
        for i := 1 to RecRef.FieldCount() do begin
            FldRef := RecRef.FieldIndex(i);
            Line :=
                Format(FldRef.Number()) + ' | ' +
                FldRef.Name() + ' | Type=' +
                Format(FldRef.Type()) + ' | Length=' +
                Format(FldRef.Length());
            Output += Line + '\n';
        end;

        // 顯示結果：開發時可改為寫入臨時表再用 page 顯示，或輸出到檔案 / telemetry
        Message('%1', Output);
    end;
}