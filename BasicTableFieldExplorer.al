page 60103 "Basic Table Field Explorer"
{
    Caption = 'Basic Table Field Explorer';
    PageType = List;
    ApplicationArea = All;
    SourceTable = Field; // 使用虛擬表 Field (2000000041)
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control)
            {
                field(TableName; Rec.TableName)
                {
                    ApplicationArea = All;
                    Caption = 'Table Name';
                    ToolTip = '輸入要檢視的表名稱（例如 user ，輸入後會自動載入欄位資料）';
                    trigger OnValidate()
                    begin
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
                field("Field No."; Rec."No.") { ApplicationArea = All; Caption = 'Field No.'; }
                field("Field Name"; Rec.FieldName) { ApplicationArea = All; Caption = 'Field Name'; }
                field("Data Type"; Rec."Type") { ApplicationArea = All; Caption = 'Data Type'; }
                // Length column removed because the virtual Field record does not have a 'Length' field
                field("Class"; Rec.Class) { ApplicationArea = All; Caption = 'Class'; }
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
        FilterDataType: Text[30];

    local procedure LoadTableFields()
    begin
        if TableId = 0 then
            exit;

        Rec.DeleteAll();
        RecRef.Open(TableId);

        for i := 1 to RecRef.FieldCount() do begin
            FldRef := RecRef.FieldIndex(i);

            if (FilterDataType <> '') and
               (StrPos(Format(FldRef.Type()), FilterDataType) = 0) then
                continue;

            Rec.Init();
            Rec."TableNo" := TableId;
            Rec."No." := FldRef.Number();
            Rec.FieldName := FldRef.Name();
            //Rec.Validate("Type", Format(FldRef.Type()));
            Rec.Insert();
        end;

        CurrPage.Update(false);
    end;

    local procedure ResolveTableId()
    begin
        Clear(TableId);
        if Rec.TableName = '' then
            exit;

        AllTables.Reset();
        AllTables.SetRange("Object Type", AllTables."Object Type"::Table);
        AllTables.SetRange("Object Caption", Rec.TableName);
        if not AllTables.FindFirst() then
            AllTables.SetRange("Object Name", Rec.TableName);

        if AllTables.FindFirst() then
            TableId := AllTables."Object ID"
        else
            Message('找不到名為 "%1" 的 Table。', Rec.TableName);
    end;
}