codeunit 50100 "LookupValue UT Customer"
{
    Subtype = Test;

    var
        LibraryUtility: Codeunit "Library - Utility";
        LibrarySales: Codeunit "Library - Sales";
        LibraryAssert: Codeunit Assert;


    trigger OnRun()
    begin
        //[FEATURE] LookupValue UT Customer 
    end;

    [Test]
    procedure AssignLookupValueToCustomer()
    var
        customer: Record Customer;
        lookUpValueCode: Code[10];
    begin
        //[SCENARIO #0001] Assign lookup value to customer
        //[GIVEN] Lookup value
        LookupValueCode := CreateLookupValueCode();

        //[GIVEN] Customer
        CreateCustomer(customer);

        //[WHEN] Set lookup value on customer
        SetLookupValueOnCustomer();
        //[THEN] Customer has lookup value code field populated
        VerifyLookupValueOnCustomer(customer."No.", lookUpValueCode);
    end;

    local procedure CreateLookupValueCode(): Code[10]
    var
        LookupValue: Record LookupValue;
    begin
        LookupValue.Init();
        LookupValue.Validate(
            Code,
            LibraryUtility.GenerateRandomCode(
                LookupValue.FieldNo(Code),
                Database::LookupValue
            )
        );
        LookupValue.Validate(Description, LookupValue.Code);
        LookupValue.Insert();
        exit(LookupValue.Code);
    end;

    local procedure CreateCustomer(var customer: Record Customer)

    begin
        LibrarySales.CreateCustomer(customer);
    end;

    local procedure SetLookupValueOnCustomer()
    var
        customer: Record Customer;
        lookupValueCode: Code[10];

    begin
        customer.Validate("Lookup Value Code", lookupValueCode);
        customer.Modify();
    end;

    local procedure VerifyLookupValueOnCustomer(customerNo: Code[20]; lookupValueCode: code[10])
    var
        customer: Record Customer;
        fieldOnTableTxt: Label '%1 on %2';
    begin
        customer.Get(customerNo);
        LibraryAssert.AreEqual(
            lookupValueCode,
            customer."Lookup Value Code",
            StrSubstNo(
                fieldOnTableTxt,
                customer.FieldCaption("Lookup Value Code"),
                customer.TableCaption()
            )
        );
    end;

    // local procedure LibraryAssertEqual(Expected: Variant; Actual: Variant; Msg: Text);

    // begin
    //     if not Equal(Expected, Actual) then
    //         Error(
    //             AreEqualFailedErr,
    //             Expected,
    //             TypeNameOf(Expected),
    //             Actual,

    //             TypeNameOf(Actual),
    //             Msg
    //         );
    //     ;
    // end;
}