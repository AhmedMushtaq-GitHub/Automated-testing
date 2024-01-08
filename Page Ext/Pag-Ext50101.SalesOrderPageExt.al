pageextension 50101 SalesOrderPageExt extends "Sales Order"
{
    layout
    {

        addlast(General)
        {
            field("Lookup Value Code"; Rec."Lookup Value Code")
            {
                ToolTip = '"Specifies the lookup value the transaction is done for"';
                ApplicationArea = All;

            }


        }
    }
}
