module APB_Controller_sva (
    input Hclk,
    input Hresetn,
    input valid,
    input Haddr1,
    input Haddr2,
    input Hwdata1,
    input Hwdata2,
    input Prdata,
    input Hwrite,
    input Haddr,
    input Hwdata,
    input Hwritereg,
    input tempselx,
    input Pwrite,
    input Penable,
    input Pselx,
    input Paddr,
    input Pwdata,
    input Hreadyout,
    input [2:0] PRESENT_STATE
);

parameter ST_IDLE     = 3'b000;
parameter ST_WWAIT    = 3'b001;
parameter ST_READ     = 3'b010;
parameter ST_WRITE    = 3'b011;
parameter ST_WRITEP   = 3'b100;
parameter ST_RENABLE  = 3'b101;
parameter ST_WENABLE  = 3'b110;
parameter ST_WENABLEP = 3'b111;



// Transitions From ST_IDLE State To Other States

property ST_IDLE_to_ST_IDLE_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_IDLE && !valid) |=> (PRESENT_STATE == ST_IDLE);

endproperty 


property ST_IDLE_to_ST_WWAIT_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_IDLE && valid && Hwrite) |=> (PRESENT_STATE == ST_WWAIT);

endproperty 


property ST_IDLE_to_ST_READ_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_IDLE && valid && !Hwrite) |=> (PRESENT_STATE == ST_READ);

endproperty 




ASSERT_ST_IDLE_TO_ST_IDLE_TRANS:  assert property (ST_IDLE_to_ST_IDLE_trans);
ASSERT_ST_IDLE_TO_ST_WWAIT_TRANS: assert property (ST_IDLE_to_ST_WWAIT_trans);
ASSERT_ST_IDLE_TO_ST_READ_TRANS:  assert property (ST_IDLE_to_ST_IDLE_trans);







// Transitions From ST_WWAIT State To Other States

property ST_WWAIT_to_ST_WRITE_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WWAIT && !valid) |=> (PRESENT_STATE == ST_WRITE);

endproperty 


property ST_WWAIT_to_ST_WRITEP_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WWAIT && valid) |=> (PRESENT_STATE == ST_WRITEP);

endproperty 

ASSERT_ST_WWAIT_TO_ST_WRITE_TRANS:  assert property (ST_WWAIT_to_ST_WRITE_trans);
ASSERT_ST_WWAIT_TO_ST_WRITEP_TRANS: assert property (ST_WWAIT_to_ST_WRITEP_trans);





// Transitions From ST_WRITEP State To Other States

property ST_WRITEP_to_ST_WENABLEP_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WRITEP) |=> (PRESENT_STATE == ST_WENABLEP);

endproperty 


ASSERT_ST_WRITEP_TO_ST_WENABLEP_TRANS:  assert property (ST_WRITEP_to_ST_WENABLEP_trans);




// Transitions From ST_WRITE State To Other States

property ST_WRITE_to_ST_WENABLEP_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WRITE && valid) |=> (PRESENT_STATE == ST_WENABLEP);

endproperty 


property ST_WRITE_to_ST_WENABLE_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WRITE && !valid) |=> (PRESENT_STATE == ST_WENABLE);

endproperty 


ASSERT_ST_WRITE_TO_ST_WENABLEP_TRANS:  assert property (ST_WRITE_to_ST_WENABLEP_trans);
ASSERT_ST_WRITE_TO_ST_WENABLE_TRANS:   assert property (ST_WRITE_to_ST_WENABLE_trans);





// Transitions From ST_WENABLEP State To Other States

property ST_WENABLEP_to_ST_WRITEP_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WENABLEP && valid && Hwritereg) |=> (PRESENT_STATE == ST_WRITEP);

endproperty


property ST_WENABLEP_to_ST_WRITE_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WENABLEP && !valid && Hwritereg) |=> (PRESENT_STATE == ST_WRITE);

endproperty 


property ST_WENABLEP_to_ST_READ_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WENABLEP && !Hwritereg) |=> (PRESENT_STATE == ST_READ);

endproperty 



ASSERT_ST_WENABLEP_TO_ST_WRITEP_TRANS:  assert property (ST_WENABLEP_to_ST_WRITEP_trans);
ASSERT_ST_WENABLEP_TO_ST_WRITE_TRANS:   assert property (ST_WENABLEP_to_ST_WRITE_trans);
ASSERT_ST_WENABLEP_TO_ST_READ_TRANS:    assert property (ST_WENABLEP_to_ST_READ_trans);





// Transitions From ST_WENABLE State To Other States

property ST_WENABLE_to_ST_READ_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WENABLE && valid && !Hwrite) |=> (PRESENT_STATE == ST_READ);

endproperty


property ST_WENABLE_to_ST_IDLE_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WENABLE && !valid) |=> (PRESENT_STATE == ST_IDLE);

endproperty 


property ST_WENABLE_to_ST_WWAIT_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_WENABLE && valid && Hwrite) |=> (PRESENT_STATE == ST_WWAIT);

endproperty 



ASSERT_ST_WENABLE_TO_ST_READ_TRANS:     assert property (ST_WENABLE_to_ST_READ_trans);
ASSERT_ST_WENABLE_TO_ST_IDLE_TRANS:     assert property (ST_WENABLE_to_ST_IDLE_trans);
ASSERT_ST_WENABLE_TO_ST_WWAIT_TRANS:    assert property (ST_WENABLE_to_ST_WWAIT_trans);




// Transitions From ST_RENABLE State To Other States

property ST_RENABLE_to_ST_READ_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_RENABLE && valid && !Hwrite) |=> (PRESENT_STATE == ST_READ);

endproperty


property ST_RENABLE_to_ST_IDLE_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_RENABLE && !valid) |=> (PRESENT_STATE == ST_IDLE);

endproperty 


property ST_RENABLE_to_ST_WWAIT_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_RENABLE && valid && Hwrite) |=> (PRESENT_STATE == ST_WWAIT);

endproperty 


ASSERT_ST_RENABLE_TO_ST_READ_TRANS:     assert property (ST_RENABLE_to_ST_READ_trans);
ASSERT_ST_RENABLE_TO_ST_IDLE_TRANS:     assert property (ST_RENABLE_to_ST_IDLE_trans);
ASSERT_ST_RENABLE_TO_ST_WWAIT_TRANS:    assert property (ST_RENABLE_to_ST_WWAIT_trans);




// Transitions From ST_READ State To Other States

property ST_READ_to_ST_RENABLE_trans ;

  @(posedge Hclk) disable iff(!Hresetn) 
  (PRESENT_STATE == ST_READ) |=> (PRESENT_STATE == ST_RENABLE);

endproperty


ASSERT_ST_READ_TO_ST_RENABLE_TRANS:    assert property (ST_READ_to_ST_RENABLE_trans);




endmodule



bind APB_Controller APB_Controller_sva APB_Controller_sva_inst (
    .Hclk          (Hclk),
    .Hresetn       (Hresetn),
    .valid         (valid),
    .Haddr1        (Haddr1),
    .Haddr2        (Haddr2),
    .Hwdata1       (Hwdata1),
    .Hwdata2       (Hwdata2),
    .Prdata        (Prdata),
    .Hwrite       (Hwrite),
    .Haddr         (Haddr),
    .Hwdata        (Hwdata),
    .Hwritereg     (Hwritereg2),
    .tempselx      (tempselx),
    .Pwrite        (Pwrite),
    .Penable       (Penable),
    .Pselx         (Pselx),
    .Paddr         (Paddr),
    .Pwdata        (Pwdata),
    .Hreadyout     (Hreadyout),
    .PRESENT_STATE (PRESENT_STATE)
);


