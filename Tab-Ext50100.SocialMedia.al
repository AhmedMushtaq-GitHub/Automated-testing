tableextension 50100 "MNB Customer " extends Customer
{

    fields
    {

        field(50105; "Lookup Value Code"; Code[10])
        {
            TableRelation = LookupValue;
        }

    }
    var
    //  BonusExistsErr: Label '"You can not delete Customer %1 because there is at least one Bonuse assigned"';


}
