codeunit 60110 "Basic User Tools"
{
    Subtype = Normal;

    procedure UpdateUserRights()
    var
        UserRec: Record User;
        AccessCtrlRec: Record "Access Control";
        UserRightsRec: Record "Basic User Rights";
        Dialog: Dialog;
        UserCount, CurrentCount, AppCount : Integer;
    begin
        // 取得使用者數量
        UserRec.Reset();
        if UserRec.Count() = 0 then begin
            Message('系統中沒有使用者資料。');
            exit;
        end;
        UserCount := UserRec.Count();

        // 清空舊資料（如不想清除可註解掉）
        if UserRightsRec.FindSet() then
            repeat
                UserRightsRec.Delete();
            until UserRightsRec.Next() = 0;

        // 開啟進度條
        Dialog.Open('正在更新 User Rights...#1##############################\#2');

        CurrentCount := 0;

        if UserRec.FindSet() then
            repeat
                CurrentCount += 1;
                Dialog.Update(1, StrSubstNo('%1 / %2', CurrentCount, UserCount));
                Dialog.Update(2, UserRec."User Name");

                // 找出使用者對應權限
                AccessCtrlRec.Reset();
                AccessCtrlRec.SetRange("User Security ID", UserRec."User Security ID");
                AppCount := AccessCtrlRec.Count();
                if AccessCtrlRec.FindSet() then
                    repeat
                        // 篩選 System Application 權限, ID 值是: {63ca2fa4-4f03-4f2b-a480-172fef340d3f}
                        if LowerCase(AccessCtrlRec."App ID") = LowerCase('{63ca2fa4-4f03-4f2b-a480-172fef340d3f}') then begin
                            UserRightsRec.Init();
                            UserRightsRec."User ID" := UserRec."User Name";
                            UserRightsRec."Permission Set ID" := AccessCtrlRec."Role ID";
                            UserRightsRec."App Name" := 'System Application';
                            UserRightsRec."Inserted Date" := CurrentDateTime();
                            UserRightsRec.Insert(true);
                        end;
                    until AccessCtrlRec.Next() = 0;
            until UserRec.Next() = 0;

        Dialog.Close();
        Message('User Rights 更新完成，共處理 %1 位使用者。', UserCount);
    end;

    // 🔹（未來可擴充更多功能）
    procedure ClearUserRights()
    var
        UserRightsRec: Record "Basic User Rights";
    begin
        if Confirm('確定要清除所有 User Rights 資料嗎？') then begin
            UserRightsRec.DeleteAll();
            Message('所有 User Rights 資料已清除。');
        end;
    end;

}