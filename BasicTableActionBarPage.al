page 60102 "Basic Table ActionBar Page"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Basic Table";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Name; Rec."Name")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AddUsers)
            {
                Caption = '新增使用者';
                ToolTip = '從使用者列表選擇多筆資料，並新增到基本資料表中，會自動略過重複項目。';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = User;

                trigger OnAction()
                var
                    UserRec: Record User;
                    BasicTableRec: Record "Basic Table";
                    //UserListPage: Page Users; // <--- 9800 是 Users, type:list 列表頁 ID 
                    SelectionCount: Integer;
                    Result: Action;
                begin
                    // 開啟標準的使用者清單頁面 (Page 9800 是 Users, type:list)
                    Result := PAGE.RunModal(9800, UserRec);

                    if Result = Action::LookupOK then begin
                        // 檢查每一筆使用者資料是否已存在
                        if UserRec.FindSet() then
                            repeat
                                BasicTableRec.Reset();
                                BasicTableRec.SetRange(Name, UserRec."User Name");
                                if BasicTableRec.IsEmpty then begin
                                    BasicTableRec.Init();

                                    // *** 關鍵修正：對於 AutoIncrement 欄位，手動將其設置為 0 (或不設置/賦值) 是必須的 ***
                                    // 雖然 Init() 已經將其設為預設值，但明確設置可以避免潛在的衝突。
                                    // 由於 ID 是 AutoIncrement，我們應該讓它保持預設值，但為了確保 Init() 沒有被其他邏輯覆蓋，
                                    // 這裡明確寫上讓其為 0，確保 Insert(true) 時能觸發自動編號。
                                    BasicTableRec.ID := 0;

                                    BasicTableRec.Name := UserRec."User Name";
                                    BasicTableRec.Description := UserRec."Full Name";
                                    BasicTableRec.Insert(true); // 自動產生新 ID
                                    SelectionCount += 1;
                                end;
                            until UserRec.Next() = 0;

                        if SelectionCount > 0 then begin
                            Message('成功新增 %1 筆使用者資料到 Basic Table 中。', SelectionCount);
                            CurrPage.Update(false);
                        end else
                            Message('沒有新的使用者資料被新增。');
                    end else
                        Message('使用者取消了新增操作。');
                end;
            }
            action(DeleteAllRecords)
            {
                Caption = '刪除所有資料';
                Image = Delete;
                trigger OnAction()
                var
                    RecRef: RecordRef;
                begin
                    RecRef.Open(Database::"Basic Table");
                    RecRef.DeleteAll();
                    RecRef.Reset();
                    Message('已清空 Basic Table 資料');
                end;
            }
        }
    }
}