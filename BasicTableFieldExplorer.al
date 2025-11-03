page 60103 "Basic Table Field Explorer"
{
    Caption = 'Basic Table Field Explorer';
    PageType = List;
    ApplicationArea = All;
    //SourceTable = Field; // 使用虛擬表 Field (2000000041) 改為使用自訂暫存表
    SourceTable = "Basic Table Field Info";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control)
            {

                field(TableName; TableName)
                {
                    ApplicationArea = All;
                    Caption = 'Table Name';
                    ToolTip = '輸入要檢視的表名稱（例如 user ，輸入後會自動載入欄位資料）';
                    trigger OnValidate()
                    begin
                        SelectedTableId := 0;
                        ResolveTableId();
                        LoadTableFields();
                    end;
                }
                field(SelectedTableId; SelectedTableId)
                {
                    ApplicationArea = All;
                    Caption = 'Select Table';
                    ToolTip = '選擇要檢視欄位的 Table';
                    TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
                    trigger OnValidate()
                    begin
                        TableName := '';
                        ResolveTableId();
                        LoadTableFields();
                    end;
                }

                field(TableId; TableId)
                {
                    ApplicationArea = All;
                    Caption = 'Table ID';
                    ToolTip = '輸入要檢視的 Table ID，例如 2000000120，輸入後會自動載入欄位資料';
                    trigger OnValidate()
                    begin
                        LoadTableFields();
                    end;
                }

                field(FilterDataType; FilterDataType)
                {
                    ApplicationArea = All;
                    Caption = '欄位型別篩選';
                    ToolTip = '可輸入型別（例如 Code, Text, Decimal），空白表示全部';
                    trigger OnValidate()
                    begin
                        LoadTableFields();
                    end;
                }
            }

            repeater(Group)
            {
                field("Table No."; Rec."Table No.") { ApplicationArea = All; Caption = 'Table No.'; }
                field("Field No."; Rec."Field No.") { ApplicationArea = All; Caption = 'Field No.'; }
                field("Field Name"; Rec."Field Name") { ApplicationArea = All; Caption = 'Field Name'; }
                field("Data Type"; Rec."Data Type") { ApplicationArea = All; Caption = 'Data Type'; }
                field("Class"; Rec."Class") { ApplicationArea = All; Caption = 'Class'; }
                field("Length"; Rec."Length") { ApplicationArea = All; Caption = 'Length'; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Reload)
            {
                Caption = '重新載入';
                ApplicationArea = All;
                Image = Refresh;
                trigger OnAction()
                begin
                    LoadTableFields();
                end;
            }
        }
    }

    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        AllTables: Record AllObjWithCaption;
        i: Integer;
        TableId: Integer;
        TableName: Text[100];
        SelectedTableId: Integer;
        FilterDataType: Text[30];

    /** 解析 table 裡所有的欄位 */
    local procedure LoadTableFields()
    var
        TempRec: Record "Basic Table Field Info" temporary;
    begin
        Rec.DeleteAll();

        if TableId = 0 then begin
            Message('請先選擇一個 Table。');
            exit;
        end;

        // 嘗試開啟指定 Table
        if not TryOpenTable(TableId) then begin
            Message('無法開啟 Table ID %1。請確認該表存在且可讀取。', TableId);
            exit;
        end;

        for i := 1 to RecRef.FieldCount() do begin
            FldRef := RecRef.FieldIndex(i);

            if (FilterDataType <> '') and
               (StrPos(Format(FldRef.Type()), FilterDataType) = 0) then
                continue;

            TempRec.Init();
            TempRec."Table No." := TableId;
            TempRec."Field No." := FldRef.Number();
            TempRec."Field Name" := FldRef.Name();
            TempRec."Data Type" := Format(FldRef.Type());
            TempRec."Class" := Format(FldRef.Class());
            TempRec."Length" := FldRef.Length();
            TempRec.Insert();
        end;
        Rec.Copy(TempRec, true);
        CurrPage.Update(false);
    end;

    /** 解析 table 的 ID 值 */
    local procedure ResolveTableId()
    begin
        Clear(TableId);
        if (TableName = '') and (SelectedTableId = 0) then
            exit;

        AllTables.Reset();
        AllTables.SetRange("Object Type", AllTables."Object Type"::Table);

        if SelectedTableId <> 0 then begin
            AllTables.SetRange("Object ID", SelectedTableId);
            if not AllTables.FindFirst() then
                AllTables.SetRange("Object ID", SelectedTableId);

            if AllTables.FindFirst() then
                TableId := AllTables."Object ID"
            else
                Message('找不到名為 "%1" 的 Table。', SelectedTableId);
        end;


        if TableName <> '' then begin
            AllTables.SetRange("Object Caption", TableName);
            if not AllTables.FindFirst() then
                AllTables.SetRange("Object Name", TableName);

            if AllTables.FindFirst() then
                TableId := AllTables."Object ID"
            else
                Message('找不到名為 "%1" 的 Table。', TableName);
        end;

    end;

    /** Record 先關閉再打開 table */
    local procedure TryOpenTable(TableId: Integer): Boolean
    var
        MetaTables: Record AllObjWithCaption;
    begin
        // 確認 Table ID 是否存在於系統物件目錄中，再嘗試開啟
        MetaTables.Reset();
        MetaTables.SetRange("Object Type", MetaTables."Object Type"::Table);
        MetaTables.SetRange("Object ID", TableId);
        if not MetaTables.FindFirst() then
            exit(false);

        // 先關閉 RecRef（即使沒有開啟也安全）
        RecRef.Close();

        // 現在安全地開啟 RecordRef（已確認 Table 存在）
        RecRef.Open(TableId);
        exit(true);
    end;


}