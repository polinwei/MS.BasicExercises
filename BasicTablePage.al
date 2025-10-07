page 60100 "Basic Table Page"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Basic Table";
    UsageCategory = Lists; // 讓它可以從搜尋直接找到

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
                    Lookup = true;

                    trigger OnLookup(var Text: Text): Boolean // <--- 注意這裡的 Text 參數
                    var
                        UserRec: Record User;
                        ConfirmReplace: Boolean;
                    begin
                        // **修正步驟 1: 將選取邏輯獨立出來**
                        if PAGE.RunModal(PAGE::Users, UserRec) = ACTION::LookupOK then begin
                            // **修正步驟 2: 將選取到的使用者名稱賦值給 Rec 欄位**
                            Rec."Name" := UserRec."User Name"; // 確定這是你希望儲存的欄位

                            // **修正步驟 3: 將新的值賦予給 Text 參數** // 這是確保在 OnLookup 結束後，欄位顯示新值的關鍵步驟
                            Text := Rec."Name";

                            // 接著處理 Description 欄位更新邏輯
                            if Rec."Description" <> '' then begin
                                ConfirmReplace := Dialog.Confirm(
                                    '此筆資料已有描述 (%1)，是否要覆寫為 "%2"？',
                                    false,
                                    Rec."Description",
                                    UserRec."Full Name"
                                );
                                if ConfirmReplace then
                                    Rec."Description" := UserRec."Full Name";
                            end else
                                Rec."Description" := UserRec."Full Name";

                            // **修正步驟 4: 移除 CurrPage.Update()**
                            // 通常情況下，當 OnLookup 傳回 true 且 Text 參數有值時，系統會自動更新欄位。
                            // 在 List 頁面上，頻繁呼叫 CurrPage.Update() 可能會導致效能問題或意外行為。

                            exit(true); // 傳回 true 表示你已經處理了查找動作
                        end else begin
                            // 使用者取消選取 → 清空欄位
                            Rec."Name" := '';
                            Rec."Description" := '';
                            Text := ''; // 同時清空 Text 參數
                            exit(true); // 傳回 true
                        end;

                        // 舊的 CurrPage.Update() 已經不需要了
                        // CurrPage.Update();
                        // exit(true); // 已經在 if/else 區塊中處理
                    end;
                }

                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}