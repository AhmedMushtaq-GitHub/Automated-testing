table 50104 LookupValue
{
    // Caption = 'LookupValue';
    // DataClassification = ToBeClassified;
    LookupPageId = Lookupvalues;


    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
