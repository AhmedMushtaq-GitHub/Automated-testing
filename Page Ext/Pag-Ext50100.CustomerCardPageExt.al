pageextension 50100 CustomerCardPageExt extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Lookup Value Code"; Rec."Lookup Value Code") { }
        }
    }
}
