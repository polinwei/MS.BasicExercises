table 60100 "Basic Table"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "ID"; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true; // 主鍵自動編號
        }

        field(2; "Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(3; "Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User ID';
        }
    }

    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
    }
}
