`include "Interface.sv"
module tb_top;
 bit clk,resetn;
 
 always #5 clk = ~ clk;
 
 initial begin
  resetn = 1;
  #5 resetn = 0;
 end
 
 fifo_if intf(clk,resetn) ;
 test t1(intf);
 fifo DUT(.rdata(intf.rdata),
          .fifo_isfull(intf.fifo_isfull),
          .fifo_isempty(intf.fifo_isempty),
          .wdata(intf.wdata),
          .i_wreq(intf.i_wreq),
          .i_rreq(intf.i_rreq),
          .clk(intf.clk),
          .resetn(intf.resetn));
endmodule