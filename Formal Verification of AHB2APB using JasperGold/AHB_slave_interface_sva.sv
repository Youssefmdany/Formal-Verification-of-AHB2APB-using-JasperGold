module AHB_slave_interface_sva(input wire Hclk,
                               input wire Hresetn,
                               input wire Hwrite,
                               input wire Hreadyin,
                               input wire [1:0] Htrans,
                               input wire [31:0] Haddr,
                               input wire [31:0] Hwdata,
                               input wire [31:0] Prdata,
                               input wire valid,
                               input wire [31:0] Haddr1,
                               input wire [31:0] Haddr2,
                               input wire [31:0] Hwdata1,
                               input wire [31:0] Hwdata2,
                               input wire [31:0] Hrdata,
                               input wire Hwritereg,
                               input wire [2:0] tempselx,
                               input wire [1:0] Hresp);

   

// properties to be proven


property ahb_vld_generation;

  @(posedge Hclk) (Hresetn && Hreadyin && (Htrans == 2'b10 || Htrans == 2'b11) && (Haddr >=32'h8000_0000 && Haddr < 32'h8C00_0000)) |-> valid ;

endproperty




property ahb_sel_slave0;

  @(posedge Hclk) (Hresetn && (Haddr >=32'h8000_0000 && Haddr < 32'h8400_0000)) |-> (tempselx ==3'b001) ;

endproperty



property ahb_sel_slave1;

  @(posedge Hclk) (Hresetn && (Haddr >=32'h8400_0000 && Haddr < 32'h8800_0000)) |-> (tempselx ==3'b010) ;

endproperty




property ahb_sel_slave2;

  @(posedge Hclk) (Hresetn && (Haddr >=32'h8800_0000 && Haddr < 32'h8c00_0000)) |-> (tempselx ==3'b100) ;

endproperty



property ahb_no_sel_slave;

  @(posedge Hclk) (Hresetn && !(Haddr >=32'h8000_0000 && Haddr < 32'h8c00_0000)) |-> (tempselx ==3'b000) ;

endproperty



property ahb_okay_response;

  @(posedge Hclk) (Hresp == 2'b00) ;

endproperty



ASSERT_AHB_VLD_GEN   : assert property (ahb_vld_generation);
ASSERT_SEL_SLAVE0    : assert property (ahb_sel_slave0);
ASSERT_SEL_SLAVE1    : assert property (ahb_sel_slave1);
ASSERT_SEL_SLAVE2    : assert property (ahb_sel_slave2);
ASSERT_NO_SEL_SLAVE  : assert property (ahb_no_sel_slave);
ASSERT_AHB_OK_RESP   : assert property (ahb_okay_response);




endmodule




bind AHB_slave_interface AHB_slave_interface_sva
    AHB_slave_interface_sva_inst (
        .Hclk      (Hclk),
        .Hresetn   (Hresetn),
        .Hwrite    (Hwrite),
        .Hreadyin  (Hreadyin),
        .Htrans    (Htrans),
        .Haddr     (Haddr),
        .Hwdata    (Hwdata),
        .Prdata    (Prdata),
        .valid     (valid),
        .Haddr1    (Haddr1),
        .Haddr2    (Haddr2),
        .Hwdata1   (Hwdata1),
        .Hwdata2   (Hwdata2),
        .Hrdata    (Hrdata),
        .Hwritereg (Hwritereg),
        .tempselx  (tempselx),
        .Hresp     (Hresp)
    );
