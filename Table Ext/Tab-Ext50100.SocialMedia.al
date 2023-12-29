tableextension 50100 "CustomerTableExt " extends Customer
{

    fields
    {

        field(50100; "Lookup Value Code"; Code[10])
        {
            TableRelation = LookupValue;
        }

    }
    var
    //  BonusExistsErr: Label '"You can not delete Customer %1 because there is at least one Bonuse assigned"';


}
