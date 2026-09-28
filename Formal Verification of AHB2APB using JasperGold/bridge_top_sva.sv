module bridge_top_sva (
    input        Hclk,
    input        Hresetn,
    input        Hwrite,
    input        Hreadyin,
    input        Hreadyout,

    input [31:0] Hwdata,
    input [31:0] Haddr,
    input [1:0]  Htrans,

    input [31:0] Prdata,

    input        Penable,
    input        Pwrite,

    input [2:0]  Pselx,
    input [31:0] Paddr,
    input [31:0] Pwdata,

    input [1:0]  Hresp,
    input [31:0] Hrdata
);


/////////////////////////////////////////
//Assumptions
/////////////////////////////////////////


property hwrite_hreadyin_asm;

  @(posedge Hclk) disable iff(!Hresetn) 
  Hwrite |-> Hreadyin[*2];

endproperty


property hreadyin_hreadyout_asm1;

  @(posedge Hclk) disable iff(!Hresetn) 
  (!Hwrite && Hreadyin) |=> (!Hreadyin until Hreadyout);

endproperty


property hreadyin_hreadyout_asm2;

  @(posedge Hclk) disable iff(!Hresetn) 
  Hreadyin[*2] |=> (!Hreadyin throughout Hreadyout[->2]);

endproperty


HWRITE_HREADYIN_ASM:
  assume property(hwrite_hreadyin_asm);

HREADYIN_HREADYOUT_ASM1:
  assume property(hreadyin_hreadyout_asm1);

HREADYIN_HREADYOUT_ASM2:
  assume property(hreadyin_hreadyout_asm2);


/////////////////////////////////////////
//Read Properties
/////////////////////////////////////////

property read_addr_range0;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && !Hwrite && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8000_0000  && Haddr <32'h8400_0000) && !($past(Hwrite) && $past(Hreadyin))) |=> (Pselx == 3'b001)[*2] ;

endproperty 


property read_addr_range1;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && !Hwrite && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8400_0000  && Haddr <32'h8800_0000) && !($past(Hwrite) && $past(Hreadyin))) |=> (Pselx == 3'b010)[*2];

endproperty 


property read_addr_range2;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && !Hwrite && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8800_0000  && Haddr <32'h8c00_0000) && !($past(Hwrite) && $past(Hreadyin))) |=> (Pselx == 3'b100)[*2];

endproperty 



property paddr_haddr_same_value_at_read;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && !Hwrite && !$past(Hwrite,1) && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8000_0000  && Haddr <32'h8c00_0000)) |=> (Paddr == $past(Haddr)) ##1 (Paddr == $past(Haddr,2));

endproperty


property prdata_hrdata_same_value;

  @(posedge Hclk) disable iff(!Hresetn) 
  Penable |-> (Prdata == Hrdata) ;

endproperty



property penable_at_read;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && !Hwrite  && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8000_0000  && Haddr <32'h8c00_0000)) |=> ##1 (Penable == 1 && Hreadyout == 1) ;

endproperty




READ_ADDR_RANGE0 : 
    assert property(read_addr_range0);

READ_ADDR_RANGE1 : 
    assert property(read_addr_range1);

READ_ADDR_RANGE2 : 
    assert property(read_addr_range2);

PADDR_HADDR_SAME_VALUE_AT_READ :
    assert property(paddr_haddr_same_value_at_read);

PRDATA_HRDATA_SAME_VALUE :
    assert property(prdata_hrdata_same_value);

PENABLE_AT_READ :
    assert property(penable_at_read);



/////////////////////////////////////////
//Write Properties
/////////////////////////////////////////


property write_addr_range0;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && Hwrite && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8000_0000  && Haddr <32'h8400_0000) && !($past(Hwrite) && $past(Hreadyin))) |=> ##1 (Pselx == 3'b001)[*2];

endproperty 



property write_addr_range1;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && Hwrite && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8400_0000  && Haddr <32'h8800_0000) && !($past(Hwrite) && $past(Hreadyin))) |=> ##1 (Pselx == 3'b010)[*2];

endproperty 



property write_addr_range2;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && Hwrite && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8800_0000  && Haddr <32'h8c00_0000) && !($past(Hwrite) && $past(Hreadyin))) |=> ##1 (Pselx == 3'b100)[*2] ;

endproperty 


property paddr_haddr_same_value_at_write;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && Hwrite && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8000_0000  && Haddr <32'h8c00_0000)) |=> ##1 (Paddr == $past(Haddr,2)) ##1 (Paddr == $past(Haddr,3));

endproperty


property pwdata_hwdata_same_value;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && Hwrite && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8000_0000  && Haddr <32'h8c00_0000)) |=> ##1 (Pwdata == $past(Hwdata,1)) ##1 (Pwdata == $past(Hwdata,2)) ;
endproperty


property penable_at_write;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && Hwrite && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8000_0000  && Haddr <32'h8c00_0000)) |=> ##2 (Penable == 1) ;

endproperty


property hreadyout_at_write;

  @(posedge Hclk) disable iff(!Hresetn) 
  (Hreadyin && Hwrite && (Htrans == 2'b11 || Htrans == 2'b10 ) && (Haddr >= 32'h8000_0000  && Haddr <32'h8c00_0000)) |=> ##2 (Hreadyout == 1) ;

endproperty



WRITE_ADDR_RANGE0 :
    assert property(write_addr_range0);

WRITE_ADDR_RANGE1 :
    assert property(write_addr_range1);

WRITE_ADDR_RANGE2 :
    assert property(write_addr_range2);

PADDR_HADDR_SAME_VALUE_AT_WRITE :
    assert property(paddr_haddr_same_value_at_write);

PWDATA_HWDATA_SAME_VALUE :
    assert property(pwdata_hwdata_same_value);

PENABLE_AT_WRITE :
    assert property(penable_at_write);

HREADYOUT_AT_WRITE :
    assert property(hreadyout_at_write);


endmodule 

bind bridge_top bridge_top_sva 
     bridge_top_sva_inst (
    .Hclk      (Hclk),
    .Hresetn   (Hresetn),
    .Hwrite    (Hwrite),
    .Hreadyin  (Hreadyin),
    .Hreadyout (Hreadyout),
    .Hwdata    (Hwdata),
    .Haddr     (Haddr),
    .Htrans    (Htrans),
    .Prdata    (Prdata),
    .Penable   (Penable),
    .Pwrite    (Pwrite),
    .Pselx     (Pselx),
    .Paddr     (Paddr),
    .Pwdata    (Pwdata),
    .Hresp     (Hresp),
    .Hrdata    (Hrdata)
);
