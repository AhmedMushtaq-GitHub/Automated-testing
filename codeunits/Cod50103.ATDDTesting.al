codeunit 50103 "ATDD Testing"


{
    Subtype = Test;
    trigger OnRun()
    begin

    end;

    var
        Assert: Codeunit Assert;
        LibrarySales: Codeunit "Library - Sales";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryWarehouse: Codeunit "Library - Warehouse";
        Customer: Record Customer;
        WarehouseEmployee: Record "Warehouse Employee";
        Item: Record Item;
        Location: Record Location;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SaleInvoiceHeader: Record "Sales Invoice Header";
        InventoryPostSetup: Record "Inventory Posting Setup";
        WarehouseShipmentManagement: Codeunit "SCM Warehouse - Shipping";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        WarehouseMgt: Codeunit "Warehouse Availability Mgt.";


    [Test]

    procedure CreateSalesOrderToPick()
    var
        CustomerNo: Code[20];
        ItemNo: code[10];
        LocationCode: Code[10];
        SaleheaderNo: code[20];
        SaleOrderNO: Code[20];
        PostSaleOrderNO: Code[20];
        WarehouseEmployeeNO: Code[20];
        WarehouseShipmentNo: Code[20];
        WarehousePickNo: Code[20];
    begin

        // [Scenario] Create Sale order with any customer and item

        // [Given Customer]
        CustomerNo := CreateCustomer();

        Customer.Get(CustomerNo);
        //[Given Item]
        ItemNo := CreateItem();
        Item.Get(ItemNo);
        //[Given Location]
        LocationCode := CreateLocation();
        Location.Get(LocationCode);
        // [When Posting inventory]

        CreateInventoryPostSetup(Location);
        //[When Creating Sale order]
        SaleOrderNO := CreateSaleOrder(Customer, Item);
        //SalesHeader.Get(SaleheaderNo);
        // [When Posting Sale Ordre]
        PostSaleOrder(SalesHeader, true, true);

        //[Then]Create Warehouse Employee
        WarehouseEmployeeNO := CreateWarehouseEmployee();
        // //[When] warehouse shipment will be created
        WarehouseShipmentNo := CreateWarehouseShipment();
        VerifyWarehouseShipment();
        // //[When]
        WarehousePickNo := CreateWarehousePick();
        // // //[Then]
        VerifyWarehousePick();
        RegisterPick();
    end;

    local procedure CreateCustomer(): Code[20]
    begin
        LibrarySales.CreateCustomer(Customer);
        exit(Customer."No.");
    end;

    local procedure CreateItem(): Code[10]
    begin
        LibraryInventory.CreateItem(Item);
        exit(Item."No.");
    end;

    local procedure CreateLocation(): Code[10]
    begin
        LibraryWarehouse.CreateLocation(Location);
        exit(Location.Code);
    end;

    local procedure CreateInventoryPostSetup(Location: Record Location)

    begin
        // LibraryInventory.CreateInventoryPostingSetup(InventoryPostSetup, Location.Code, Item."Inventory Posting Group");
        LibraryInventory.UpdateInventoryPostingSetup(Location);
    end;

    local procedure CreateSaleOrder(customer: Record Customer; item: Record Item): Code[20]
    begin
        LibrarySales.CreateSalesDocumentWithItem(SalesHeader, SalesLine, SalesHeader."Document Type"::Order, Customer."No.", Item."No.", 5, Location.Code, WorkDate());
        LibrarySales.ReleaseSalesDocument(SalesHeader);
        exit(SalesHeader."No.");
    end;

    local procedure PostSaleOrder(var SalesHeader: Record "Sales Header"; NewShipRecive: Boolean; NewInvoice: Boolean): Code[20]
    begin
        LibrarySales.PostSalesDocument(SalesHeader, true, true);
    end;

    local procedure VerifySaleOrder()
    begin
        SaleInvoiceHeader.SetRange("External Document No.", SalesHeader."External Document No.");
        SaleInvoiceHeader.FindFirst();
        Assert.AreEqual(SaleInvoiceHeader."Sell-to Customer No.", SalesHeader."Sell-to Customer No.", 'Data Not found');
    end;


    local procedure CreateInventoryPostSetup()
    begin
        // LibraryInventory.CreateInventoryPostingSetup(InventoryPostSetup, Location.Code, Item."Inventory Posting Group");
        LibraryInventory.UpdateInventoryPostingSetup(Location);
    end;

    local procedure CreateSaleOrder()
    begin
        LibrarySales.CreateSalesDocumentWithItem(SalesHeader, SalesLine, SalesHeader."Document Type"::Order, Customer."No.", Item."No.", 5, Location.Code, WorkDate());
        LibrarySales.ReleaseSalesDocument(SalesHeader);
    end;

    local procedure PostSaleOrder()
    begin
        LibrarySales.PostSalesDocument(SalesHeader, true, true);
    end;

    local procedure CreateWarehouseEmployee(): Code[20]
    begin
        LibraryWarehouse.CreateWarehouseEmployee(WarehouseEmployee, Location.Code, true);
        exit(WarehouseEmployee."User ID");
    end;

    local procedure CreateWarehouseShipment(): Code[20]
    var

    begin
        // Update Bin Code in Warehouse Shipment Lines
        // WarehouseShipmentLine.RESET;
        // WarehouseShipmentHeader.RESET;
        // // Your code to initialize WarehouseShipmentHeader and WarehouseShipmentLine records
        // // Change Bin Code in Warehouse Shipment Header
        // WarehouseShipmentHeader."Bin Code" := 'SHIPDC';  // Replace 'NewBinCode' with your desired bin code
        // WarehouseShipmentLine."Bin Code" := 'SHIPDC';
        // // Save changes
        // WarehouseShipmentHeader.MODIFY;
        // WarehouseShipmentLine.MODIFY;
        LibraryWarehouse.CreateWarehouseShipmentHeader(WarehouseShipmentHeader);
        LibraryWarehouse.CreateWarehouseShipmentLine(WarehouseShipmentLine, WarehouseShipmentHeader);
        exit(WarehouseShipmentHeader."No.");
    end;

    local procedure VerifyWarehouseShipment()
    begin
        WarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
        WarehouseShipmentLine.FindFirst();
        Assert.AreEqual(WarehouseShipmentLine."No.", WarehouseShipmentHeader."No.", ' Data not found');

    end;

    local procedure CreateWarehousePick(): Code[20]

    begin
        LibraryWarehouse.AutofillQtyToShipWhseShipment(WarehouseShipmentHeader);
        LibraryWarehouse.CreatePick(WarehouseShipmentHeader);
        exit(WarehouseShipmentHeader."No.");
    end;



    local procedure VerifyWarehousePick()

    begin
        WarehouseActivityLine.SetRange("No.", WarehouseShipmentHeader."No.");
        WarehouseActivityLine.FindFirst();
        Assert.AreEqual(WarehouseShipmentLine."Source No.", WarehouseActivityLine."Source No.", 'Data Not Found');

    end;

    local procedure RegisterPick()

    begin

    end;
}
