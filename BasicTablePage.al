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
                field("ID"; Rec."ID") { ApplicationArea = All; Editable = false; }
                field("Name"; Rec."Name") { ApplicationArea = All; }
                field("Description"; Rec."Description") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SayTableRecord)
            {
                Caption = 'Say Table Record';
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecCopy: Record "Basic Table";
                begin
                    if Rec.Get(Rec."ID") then begin
                        Message('Hello, %1!', Rec."ID".ToText() + Rec."Name");
                    end;
                end;
            }
        }
    }
}