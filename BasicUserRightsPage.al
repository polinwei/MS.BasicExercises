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
                field("User ID"; Rec."User ID") { ApplicationArea = All; }
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