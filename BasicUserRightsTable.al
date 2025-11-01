table 60110 "Basic User Rights"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[50]) { Caption = 'User ID'; }
        field(2; "Permission Set ID"; Code[50]) { Caption = 'Permission Set ID'; }
        field(3; "App Name"; Text[100]) { Caption = 'Application Name'; }
        field(4; "Inserted Date"; DateTime) { Caption = 'Inserted Date'; }
    }

    keys
    {
        key(PK; "User ID", "Permission Set ID") { Clustered = true; }
    }
}