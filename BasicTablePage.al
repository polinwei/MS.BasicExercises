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

                            // **修正步驟 3: 將新的值賦予給 Text 參數** 
                            // 這是確保在 OnLookup 結束後，欄位顯示新值的關鍵步驟
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
    actions
    {
        area(Processing)
        {
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

            // **新增按鍵 action(AddUsers)**
            action(AddUsers)
            {
                Caption = '從 Users 新增多筆';
                Image = User;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    UserPage: Page Users; // 宣告 Users 頁面的變數
                    UserRec: Record User; // 宣告 User Table 的 Record 變數
                    BasicTableRec: Record "Basic Table"; // 宣告 Basic Table 的 Record 變數
                    UsersAdded: Integer;
                begin
                    // 設定 Users 頁面為 Lookup 模式，允許多選
                    UserPage.LookupMode(true);

                    // 執行 Users 頁面，並檢查是否點擊了 "OK"
                    if UserPage.RunModal() = ACTION::LookupOK then begin

                        // 取得使用者在 Users 頁面選中的記錄篩選器
                        UserPage.GetRecord(UserRec); // 取得第一個選中的記錄並設定給 UserRec
                        UserPage.SetSelectionFilter(UserRec); // 將選取的篩選器設定給 UserRec

                        UsersAdded := 0;
                        // 遍歷所有選中的使用者
                        if UserRec.FindSet() then begin
                            repeat
                                // 準備一筆新的 Basic Table 記錄
                                BasicTableRec.Init();
                                Clear(BasicTableRec); // 清乾淨，避免沿用舊 ID
                                // 將選中的使用者資料賦值給新記錄
                                BasicTableRec.Name := UserRec."User Name";
                                BasicTableRec.Description := UserRec."Full Name";

                                // 插入新記錄。如果 ID 是 AutoIncrement (如 BasicTable.al)，
                                // 則不需要手動設定 ID。
                                BasicTableRec.Insert(true); // true 參數表示即使記錄已存在也不報錯 (通常用於有 Key 衝突時)
                                UsersAdded += 1;
                            until UserRec.Next() = 0;
                        end;

                        // 刷新當前頁面以顯示新增的記錄
                        CurrPage.Update();

                        // 顯示新增結果
                        Message('%1 筆使用者資料已成功新增到 Basic Table。', UsersAdded);
                    end;
                end;
            }
            // **新增按鍵 action(AddUsers) 結束**
        }
    }
}