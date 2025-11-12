page 60110 "Basic User Rights List"
{
    PageType = List;
    SourceTable = "Basic User Rights";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'User Rights';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    // 1. 啟用連結外觀
                    DrillDown = true;
                    // 2. 新增 OnDrillDown 觸發器
                    trigger OnDrillDown()
                    var
                        UserRec: Record User;
                        UserCardPage: Page "User Card"; // 假設 User Card 頁面 ID 是 9807
                    begin
                        // 確保 Rec."User ID" 有值
                        if Rec."User ID" <> '' then begin
                            // 1. 根據 Name 欄位 (User Name) 篩選 User 記錄
                            UserRec.SetRange("User Name", Rec."User ID");

                            // 2. 找到該使用者
                            if UserRec.FindFirst() then begin
                                // 3. 開啟 User Card 頁面，並將 UserRec 傳入
                                //    RunModal 將以卡片頁模式彈出，顯示該筆 User 記錄
                                UserCardPage.SetRecord(UserRec);
                                UserCardPage.RunModal();
                            end else begin
                                Message('找不到使用者ID為 "%1" 的使用者記錄。', Rec."User ID");
                            end;
                        end;
                    end;
                }
                field("Permission Set ID"; Rec."Permission Set ID") { ApplicationArea = All; }
                field("App Name"; Rec."App Name") { ApplicationArea = All; }
                field("Inserted Date"; Rec."Inserted Date") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshRights)
            {
                Caption = '重新更新 User Rights';
                Image = Refresh;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = '重新擷取並更新 User Rights 資料。';

                trigger OnAction()
                var
                    UserRightsTools: Codeunit "Basic User Tools";
                begin
                    if Confirm('確定要重新更新 User Rights 資料嗎？') then
                        UserRightsTools.UpdateUserRights();
                end;
            }

            action(ClearRights)
            {
                Caption = '清除 User Rights';
                Image = Delete;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = '清除所有 User Rights 資料。';

                trigger OnAction()
                var
                    UserRightsTools: Codeunit "Basic User Tools";
                begin
                    UserRightsTools.ClearUserRights();
                end;
            }
        }
    }
}