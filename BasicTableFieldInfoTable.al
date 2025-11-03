table 60104 "Basic Table Field Info"
{
    Caption = 'Basic Table Field Info(暫存記錄 table 的欄位型別資訊)';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Table No."; Integer) { Caption = 'Table No.'; }
        field(2; "Field No."; Integer) { Caption = 'Field No.'; }
        field(3; "Field Name"; Text[100]) { Caption = 'Field Name'; }
        field(4; "Data Type"; Text[30]) { Caption = 'Data Type'; }
        field(5; "Class"; Text[30]) { Caption = 'Class'; }
        field(6; "Length"; Integer) { Caption = 'Length'; }
    }

    keys
    {
        key(PK; "Table No.", "Field No.") { Clustered = true; }
    }
}