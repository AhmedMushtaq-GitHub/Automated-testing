codeunit 50101 "LookupValue UT Sales Document"
{
    Subtype = Test;
    trigger OnRun()


    begin
        //[FEATURE] LookupValue UT Sales Document
    end;

    var
        Assert: Codeunit Assert;
        LibrarySales: Codeunit "Library - Sales";
        LibraryUtility: Codeunit "Library - Utility";
        isInitialized: Boolean;
        lookupvalueCode: code[10];
        LookupValueUTCustomer: Codeunit "LookupValue UT Customer";


    [Test]
    procedure AssignLookupValueToSalesHeader()
    var
        salesHeader: Record "Sales Header";
        documentNo: Code[20];

    begin
        //[SCENARIO #0004] Assign lookup value to sales header page
        //[GIVEN] Lookup value
        Initialize();
        //[GIVEN] Sales header
        CreateSalesHeader(salesHeader);
        //[WHEN] Set lookup value on sales header
        SetLookupValueOnSalesHeader(salesHeader, lookupvalueCode);
        //[THEN] Sales header has lookup value code field populated
        VerifyLookupValueOnSalesHeader(SalesHeader."Document Type", SalesHeader."No.", LookupValueCode);
    end;
    //----------
    local procedure CreateSalesHeader(var salesHeader: Record "Sales Header")

    begin
        LibrarySales.CreateSalesHeader(salesHeader, salesHeader."Document Type"::Order, '');

    end;

    local procedure SetLookupValueOnSalesHeader(var salesHeader: Record "Sales Header"; lookupValueCode: Code[10])
    begin
        salesHeader.Validate("Lookup Value Code", lookupValueCode);
        salesHeader.Modify();
    end;

    local procedure VerifyLookupValueOnSalesHeader(DocumentType: Option "Sales Document Type"; DocumentNo: Code[20]; LookupValueCode: Code[10])
    var
        SalesHeader: Record "Sales Header";
        FieldOnTableTxt: Label '%1 on %2';
    // this smells like duplication ;-) - see test example 1
    begin
        SalesHeader.Get(DocumentType, DocumentNo);
        Assert.AreEqual(
            LookupValueCode,
            SalesHeader."Lookup Value Code",
            StrSubstNo(
                FieldOnTableTxt,
                SalesHeader.FieldCaption("Lookup Value Code"),
                SalesHeader.TableCaption())
            );
    end;

    [Test]
    procedure AssignLookupValueToSalesQuoteDocument()
    begin
        //[SCENARIO #0006] Assign lookup value on sales quote
        // document page
        //[GIVEN] Lookup value
        //[GIVEN] Sales quote document page
        //[WHEN] Set lookup value on sales quote document
        //[THEN] Sales quote has lookup value code field populated
    end;

    [Test]
    procedure AssignLookupValueToSalesOrderDocument()
    var
        salesHeader: Record "Sales Header";
        salesDocument: TestPage "Sales Order";
        documentNo: Code[20];
    begin
        //[SCENARIO #0007] Assign lookup value on sales order
        // document page
        //[GIVEN] Lookup value
        //CreateLookupValueCode();
        Initialize();
        //[GIVEN] Sales order document page
        CreateSalesOrderDocument(salesDocument);
        //[WHEN] Set lookup value on sales order document
        documentNo := SetLookupValueOnSalesOrderDocument(salesDocument, lookupvalueCode);
        //[THEN] Sales order has lookup value code field populated
        VerifyLookupValueOnSaleHeader(documentNo, lookupvalueCode, salesHeader."Document Type"::Order);
    end;

    local procedure Initialize()
    var

    begin
        if isInitialized then
            exit;
        //inheriting codeunit 50107
        LookupValueCode := LookupValueUTCustomer.CreateLookupValueCode();
        isInitialized := true;
        Commit();
    end;


    local procedure CreateSalesOrderDocument(
    var SalesDocument: TestPage "Sales Order")
    begin
        SalesDocument.OpenNew();
    end;

    local procedure SetLookupValueOnSalesOrderDocument(
    var SalesDocument: TestPage "Sales Order";
    LookupValueCode: Code[10])

    DocumentNo: Code[20]

    begin

        Assert.IsTrue(
                    SalesDocument."Lookup Value Code".Editable(),
                    'Editable'
                );
        SalesDocument."Lookup Value Code".SetValue(lookupValueCode);
        DocumentNo := SalesDocument."No.".Value();
        SalesDocument.Close();
    end;

    local procedure VerifyLookupValueOnSaleHeader(
        DocumentNo: Code[20];
        LookupValueCode: Code[10];
        DocumentType: Option "Sales Document Type"

    )
    var
        salesHeader: Record "Sales Header";
        fieldOnTableTxt: Label '%1 on %2';

    begin
        salesHeader.Get(DocumentNo, DocumentType);
        Assert.AreEqual(
            lookupValueCode,
            salesHeader."Lookup Value Code",
            StrSubstNo(
                fieldOnTableTxt,
                salesHeader.FieldCaption("Lookup Value Code"),
                salesHeader.TableCaption()
            )
        );
    end;
}
