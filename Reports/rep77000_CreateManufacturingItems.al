report 77000 "BAC Create Manuf Item"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(OffSetItemNo; OffSetItemNo)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnInitReport()
    begin
        OffSetItemNo := 90000;
    end;

    trigger OnPreReport()
    var
        item: Record Item;
    begin
        if Item.Get(Format(OffSetItemNo)) then
            if Confirm(ItemsExist) then
                DeleteItems;

        if not Confirm(AreYouSureTxt) then
            exit;

        CreateItems;
        Message(DoneTxt);
    end;

    var
        OffSetItemNo: Integer;
        RawMatNo: Integer;
        FinishedTxt: Label 'Finished %1';
        SemiTxt: Label 'Subassembly %1';
        RawTxt: Label 'Raw Material %1';
        AreYouSureTxt: Label 'Create Test Items - Are you sure?';
        DoneTxt: Label 'Done';
        ItemsExist: Label 'Items Exist already - delete test items?';

    local procedure CreateItems()
    var
        Item: Record Item;
        Item2: Record Item;
    begin
        Item.Init;
        Item."No." := Format(OffSetItemNo);
        Item.Insert;
        Item.Validate(Description, StrSubstNo(FinishedTxt, Item.TableCaption));
        Item2.Get('1000');
        Item.Validate("Base Unit of Measure", Item2."Base Unit of Measure");
        Item.Validate("Gen. Prod. Posting Group", Item2."Gen. Prod. Posting Group");
        Item.Validate("Inventory Posting Group", Item2."Inventory Posting Group");
        Item.Validate("Costing Method", Item."Costing Method"::FIFO);
        Item.Validate("Replenishment System", Item."Replenishment System"::"Prod. Order");
        Item.Validate("Reordering Policy", Item."Reordering Policy"::"Lot-for-Lot");
        Item.Validate("Manufacturing Policy", Item."Manufacturing Policy"::"Make-to-Order");
        Item."Production BOM No." := Item."No.";
        Item."Routing No." := Item."No.";
        Item.Modify;

        CreateFinishedBom(Item);
        CreateRoutingHeaders(Item);

        OffSetItemNo += 1000;

        Item.Init;
        Item."No." := Format(OffSetItemNo);
        Item.Insert;
        Item.Validate(Description, StrSubstNo(SemiTxt, Item.TableCaption));
        Item.Validate("Base Unit of Measure", Item2."Base Unit of Measure");
        Item.Validate("Gen. Prod. Posting Group", Item2."Gen. Prod. Posting Group");
        Item.Validate("Inventory Posting Group", Item2."Inventory Posting Group");
        Item.Validate("Costing Method", Item."Costing Method"::FIFO);
        Item.Validate("Replenishment System", Item."Replenishment System"::"Prod. Order");
        Item.Validate("Reordering Policy", Item."Reordering Policy"::"Lot-for-Lot");
        Item.Validate("Manufacturing Policy", Item."Manufacturing Policy"::"Make-to-Order");
        Item."Production BOM No." := Item."No.";
        Item."Routing No." := Item."No.";
        Item.Modify;

        CreateSemiBom(Item);
        CreateRoutingHeaders(Item);

        RawMatNo := 1;
        OffSetItemNo += 1000 + RawMatNo;
        Item.Init;
        Item."No." := Format(OffSetItemNo);
        Item.Insert;
        Item.Validate(Description, StrSubstNo(RawTxt, RawMatNo));
        Item2.Get('1120');
        Item.Validate("Base Unit of Measure", Item2."Base Unit of Measure");
        Item.Validate("Gen. Prod. Posting Group", Item2."Gen. Prod. Posting Group");
        Item.Validate("Inventory Posting Group", Item2."Inventory Posting Group");
        Item.Validate("Costing Method", Item."Costing Method"::FIFO);
        Item.Validate("Replenishment System", Item."Replenishment System"::Purchase);
        Item.Validate("Reordering Policy", Item."Reordering Policy"::"Lot-for-Lot");
        Item.Validate("Unit Cost", 10);
        Item.Validate("Standard Cost", 10);
        Item.Modify;

        RawMatNo += 1;
        OffSetItemNo += 1;
        Item.Init;
        Item."No." := Format(OffSetItemNo);
        Item.Insert;
        Item.Validate(Description, StrSubstNo(RawTxt, RawMatNo));
        Item.Validate("Base Unit of Measure", Item2."Base Unit of Measure");
        Item.Validate("Gen. Prod. Posting Group", Item2."Gen. Prod. Posting Group");
        Item.Validate("Inventory Posting Group", Item2."Inventory Posting Group");
        Item.Validate("Costing Method", Item."Costing Method"::FIFO);
        Item.Validate("Replenishment System", Item."Replenishment System"::Purchase);
        Item.Validate("Reordering Policy", Item."Reordering Policy"::"Lot-for-Lot");
        Item.Validate("Manufacturing Policy", Item."Manufacturing Policy"::"Make-to-Order");
        Item.Validate("Unit Cost", 11);
        Item.Validate("Standard Cost", 11);
        Item.Modify;

        RawMatNo += 1;
        OffSetItemNo += 1;
        Item.Init;
        Item."No." := Format(OffSetItemNo);
        Item.Insert;
        Item.Validate(Description, StrSubstNo(RawTxt, RawMatNo));
        Item.Validate("Base Unit of Measure", Item2."Base Unit of Measure");
        Item.Validate("Gen. Prod. Posting Group", Item2."Gen. Prod. Posting Group");
        Item.Validate("Inventory Posting Group", Item2."Inventory Posting Group");
        Item.Validate("Costing Method", Item."Costing Method"::FIFO);
        Item.Validate("Replenishment System", Item."Replenishment System"::Purchase);
        Item.Validate("Reordering Policy", Item."Reordering Policy"::"Lot-for-Lot");
        Item.Validate("Manufacturing Policy", Item."Manufacturing Policy"::"Make-to-Order");
        Item.Validate("Unit Cost", 12);
        Item.Validate("Standard Cost", 12);
        Item.Modify;
    end;

    local procedure CreateFinishedBom(inItem: Record Item)
    var
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMLine: Record "Production BOM Line";
    begin
        ProdBOMHeader.Init;
        ProdBOMHeader."No." := inItem."No.";
        ProdBOMHeader.Description := StrSubstNo(FinishedTxt, ProdBOMHeader.TableCaption);
        ProdBOMHeader."Unit of Measure Code" := inItem."Base Unit of Measure";
        ProdBOMHeader.Insert;
        ProdBOMLine.Init;
        ProdBOMLine."Production BOM No." := ProdBOMHeader."No.";
        ProdBOMLine."Line No." := 10000;
        ProdBOMLine.Type := ProdBOMLine.Type::Item;
        ProdBOMLine."No." := Format(OffSetItemNo + 1000);
        ProdBOMLine.Description := StrSubstNo(SemiTxt, inItem.TableCaption);
        ProdBOMLine."Unit of Measure Code" := inItem."Base Unit of Measure";
        ProdBOMLine.Quantity := 1;
        ProdBOMLine."Quantity per" := 1;
        ProdBOMLine.Insert;

        ProdBOMLine.Init;
        ProdBOMLine."Production BOM No." := ProdBOMHeader."No.";
        ProdBOMLine."Line No." := 20000;
        ProdBOMLine.Type := ProdBOMLine.Type::Item;
        ProdBOMLine."No." := Format(OffSetItemNo + 2001);
        ProdBOMLine.Description := StrSubstNo(RawTxt, 1);
        ProdBOMLine."Unit of Measure Code" := inItem."Base Unit of Measure";
        ProdBOMLine.Quantity := 1;
        ProdBOMLine."Quantity per" := 1;
        ProdBOMLine.Insert;
    end;

    local procedure CreateSemiBom(inItem: Record Item)
    var
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMLine: Record "Production BOM Line";
    begin
        ProdBOMHeader.Init;
        ProdBOMHeader."No." := inItem."No.";
        ProdBOMHeader.Description := StrSubstNo(SemiTxt, ProdBOMHeader.TableCaption);
        ProdBOMHeader."Unit of Measure Code" := inItem."Base Unit of Measure";
        ProdBOMHeader.Insert;
        ProdBOMLine.Init;
        ProdBOMLine."Production BOM No." := ProdBOMHeader."No.";
        ProdBOMLine."Line No." := 10000;
        ProdBOMLine.Type := ProdBOMLine.Type::Item;
        ProdBOMLine."No." := Format(OffSetItemNo + 1002);
        ProdBOMLine.Description := StrSubstNo(RawTxt, 2);
        ProdBOMLine."Unit of Measure Code" := inItem."Base Unit of Measure";
        ProdBOMLine.Quantity := 1;
        ProdBOMLine."Quantity per" := 1;
        ProdBOMLine.Insert;

        ProdBOMLine.Init;
        ProdBOMLine."Production BOM No." := ProdBOMHeader."No.";
        ProdBOMLine."Line No." := 20000;
        ProdBOMLine.Type := ProdBOMLine.Type::Item;
        ProdBOMLine."No." := Format(OffSetItemNo + 1003);
        ProdBOMLine.Description := StrSubstNo(RawTxt, 3);
        ProdBOMLine."Unit of Measure Code" := inItem."Base Unit of Measure";
        ProdBOMLine.Quantity := 1;
        ProdBOMLine."Quantity per" := 1;
        ProdBOMLine.Insert;
    end;

    local procedure CreateRoutingHeaders(inItem: Record Item)
    var
        RoutingHeader: Record "Routing Header";
        RoutingLine: Record "Routing Line";
    begin
        RoutingHeader."No." := inItem."No.";
        case inItem."No." of
            Format(OffSetItemNo):
                RoutingHeader.Description := StrSubstNo(FinishedTxt, RoutingHeader.TableCaption);
            else
                RoutingHeader.Description := StrSubstNo(SemiTxt, RoutingHeader.TableCaption);
        end;
        RoutingHeader.Insert;
        RoutingLine.Init;
        RoutingLine."Routing No." := RoutingHeader."No.";
        RoutingLine.Validate("Operation No.", '010');
        RoutingLine.Validate(Type, RoutingLine.Type::"Work Center");
        RoutingLine.Validate("No.", '100');
        RoutingLine."Setup Time" := 10;
        RoutingLine."Run Time" := 10;
        RoutingLine.Insert;

        RoutingLine.Validate("Operation No.", '020');
        RoutingLine.Validate("No.", '300');
        RoutingLine.Insert;

        RoutingLine.Validate("Operation No.", '030');
        RoutingLine.Validate("No.", '200');
        RoutingLine.Insert;
    end;

    local procedure DeleteItems()
    var
        Item: Record Item;
        RoutingHeader: Record "Routing Header";
        ProdBOMHeader: Record "Production BOM Header";
    begin

        if Item.Get(Format(OffSetItemNo)) then begin
            Item."Routing No." := '';
            Item."Production BOM No." := '';
            Item.Modify;
            Item.Delete(true);
        end;

        if RoutingHeader.Get(Format(OffSetItemNo)) then begin
            RoutingHeader.Status := RoutingHeader.Status::New;
            RoutingHeader.Modify;
            RoutingHeader.Delete(true);
        end;

        if ProdBOMHeader.Get(Format(OffSetItemNo)) then begin
            ProdBOMHeader.Status := ProdBOMHeader.Status::New;
            ProdBOMHeader.Modify;
            ProdBOMHeader.Delete(true);
        end;

        if Item.Get(Format(OffSetItemNo + 1000)) then begin
            Item."Routing No." := '';
            Item."Production BOM No." := '';
            Item.Modify;
            Item.Delete(true);
        end;

        if RoutingHeader.Get(Format(OffSetItemNo + 1000)) then begin
            RoutingHeader.Status := RoutingHeader.Status::New;
            RoutingHeader.Modify;
            RoutingHeader.Delete(true);
        end;

        if ProdBOMHeader.Get(Format(OffSetItemNo + 1000)) then begin
            ProdBOMHeader.Status := ProdBOMHeader.Status::New;
            ProdBOMHeader.Modify;
            ProdBOMHeader.Delete(true);
        end;

        if Item.Get(Format(OffSetItemNo + 2001)) then
            Item.Delete(true);

        if Item.Get(Format(OffSetItemNo + 2002)) then
            Item.Delete(true);

        if Item.Get(Format(OffSetItemNo + 2003)) then
            Item.Delete(true);
    end;
}