codeunit 50102 "LookupValue UT Customer"
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
    //SCENARIO #0001---------------------------------------------------------------------------------
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
        SetLookupValueOnCustomer(customer, lookupValueCode);
        //[THEN] Customer has lookup value code field populated
        VerifyLookupValueOnCustomer(customer."No.", lookUpValueCode);
    end;
    //SCENARIO #0002---------------------------------------------------------------------------------
    [Test]
    procedure AssignNonExistingLookupValueToCustomer()
    var
        customer: Record Customer;
        lookupValueCode: Code[10];
    begin
        //[SCENARIO #0002] Assign non-existing lookup value to customer

        //[GIVEN] Non-existing lookup value
        lookupValueCode := 'SC #0002';
        //[GIVEN] Customer record variable

        //[WHEN] Set non-existing lookup value on customer
        asserterror SetLookupValueOnCustomer(customer, lookupValueCode);
        //[THEN] Non existing lookup value error thrown
        VerifyNonExistingLookupValueError(lookupValueCode);
        //[THEN] Non existing lookup value error thrown
        //VerifyNonExistingLookupValueError('LUC');


    end;
    //SCENARIO #0003---------------------------------------------------------------------------------
    [Test]
    procedure "Assign lookup value on customer card"()
    var
        customerCard: TestPage "Customer Card";
        customerNo: Code[20];
        lookupValueCode: Code[10];
    begin

        // [SCENARIO #0003] Assign lookup value on customer card
        // [GIVEN] Lookup value
        lookupValueCode := CreateLookupValueCode();
        // [GIVEN] Customer card
        CreateCustomerCrad(customerCard);
        // [WHEN] Set lookup value on customer card
        customerNo := SetLookupValueOnCustomerCard(customerCard, lookupValueCode);
        // [THEN] Customer has lookup value code field populated
        VerifyLookupValueOnCustomer(customerNo, lookupValueCode);

    end;
    //procedures SCENARIO #0001////////////////////////////////////////////////////
    procedure CreateLookupValueCode(): Code[10]
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

    local procedure SetLookupValueOnCustomer(var customer: Record Customer; lookupValueCode: Code[10])


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

    local procedure LibraryAssertEqual(Expected: Variant; Actual: Variant; Msg: Text);

    begin
        // if not Equal(Expected, Actual) then
        //     Error(
        //         AreEqualFailedErr,
        //         Expected,
        //         TypeNameOf(Expected),
        //         Actual,

        //         TypeNameOf(Actual),
        //         Msg
        //     );
        // ;
    end;
    //procedures SCENARIO #0002////////////////////////////////////////////////////



    local procedure VerifyNonExistingLookupValueError(lookupValueCode: Code[10])
    var
        customer: Record Customer;
        lookupValue: Record LookupValue;
        valueCannotBeFoundInTableTxt: Label
        'The field %1 of table %1 contains a value (%3) that cannot be found in the related table (%4).';
    begin
        LibraryAssert.ExpectedError(
        StrSubstNo(
        valueCannotBeFoundInTableTxt,
        customer.FieldCaption("Lookup Value Code"),
        customer.TableCaption(),
        lookupValueCode,
        lookupValue.TableCaption()
)
        );
    end;

    //procedures SCENARIO #0003////////////////////////////////////////////////////
    local procedure CreateCustomerCrad(Var
        customerCard: TestPage "Customer Card")


    begin
        customerCard.OpenNew();
    end;

    local procedure SetLookupValueOnCustomerCard(var customerCard: TestPage "Customer Card";
    lookupValueCode: Code[10])

    CustomerNO: code[20]


    begin
        LibraryAssert.IsTrue(
            customerCard."Lookup Value Code".Editable(),
            'Editable'
        );
        customerCard."Lookup Value Code".SetValue(lookupValueCode);
        CustomerNO := customerCard."No.".Value();
        customerCard.Close();
    end;
}