pageextension 60110 "Basic User List Ext" extends "Users"
{
    actions
    {
        addlast(Processing)
        {
            action(UpdateUserRights)
            {
                Caption = '更新 User Rights';
                Image = Process;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = '根據 Access Control (使用者權限) 更新 User Rights 表。';

                trigger OnAction()
                var
                    UserRightsUpdater: Codeunit "Basic User Tools";
                begin
                    if Confirm('是否要更新 User Rights 資料？') then
                        UserRightsUpdater.UpdateUserRights();
                end;
            }
        }
    }
}
