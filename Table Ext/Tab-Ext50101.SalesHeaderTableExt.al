tableextension 50101 SalesHeaderTableExt extends "Sales Header"
{
    fields
    {
        field(50100; "Lookup Value Code"; Code[10])
        {
            Caption = 'Lookup Value Code';
            DataClassification = ToBeClassified;
            TableRelation = "LookupValue";
        }
    }
}
