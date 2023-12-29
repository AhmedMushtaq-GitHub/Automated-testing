page 50107 Lookupvalues
{
    //ApplicationArea = All;
    Caption = 'Lookupvalues';
    PageType = List;
    SourceTable = LookupValue;

    layout
    {
        area(content)
        {
            repeater(RepeaterControl)
            {
                field(Code; Rec.Code)
                {

                }
                field(Description; Rec.Description)
                {

                }

            }
        }
    }
}
