`include "Packet.sv"
//`include "Packet.sv"

`define DRIVER_IF fifo_if.DRIVER.driver_cb
//DRIVER_IF points to the DRIVER modport in interface
class driver;
  
  int no_pkt;
  virtual fifo_if vif_fifo;
  mailbox gen2drv;
  
  function new(virtual fifo_if vif_fifo,mailbox gen2drv);
    this.vif_fifo = vif_fifo;
    this.gen2drv = gen2drv;
  endfunction  
  
  task reset;
    $display("resetting");
    wait(vif_fifo.resetn);
    fifo_if.DRIVER.driver_cb.wdata <= 0;
    `DRIVER_IF.i_wreq <= 0;
    `DRIVER_IF.i_rreq <= 0;
    wait(!vif_fifo.resetn);
    $display("done resetting");
  endtask
  
  task drive;
    forever begin
      packet pkt;
     `DRIVER_IF.i_wreq <=0;
     `DRIVER_IF.i_rreq <=0;
     gen2drv.get(pkt);
     $display("no: of transactions = ",no_pkt);
     
     @(posedge `DRIVER_IF.clk);
     if(pkt.i_wreq)begin
      `DRIVER_IF.i_wreq <= pkt.i_wreq;
      `DRIVER_IF.wdata  <= pkt.wdata;
       pkt.fifo_isfull   = `DRIVER_IF.fifo_isfull;
       pkt.fifo_isempty  = `DRIVER_IF.fifo_isempty;
      $display("\t write enable = %0h \t data input = %0h",pkt.i_wreq,pkt.wdata);
     end
     
     if(pkt.i_rreq)begin
      `DRIVER_IF.i_rreq <= pkt.i_rreq;
      @(posedge `DRIVER_IF.clk);
      `DRIVER_IF.i_rreq <= 0;
      @(posedge `DRIVER_IF.clk);
       pkt.rdata =`DRIVER_IF.rdata  ;
       pkt.fifo_isfull = `DRIVER_IF.fifo_isfull;
       pkt.fifo_isempty =`DRIVER_IF.fifo_isempty;

      $display("\t read enable = %0h \t data output = %0h",pkt.i_rreq,pkt.rdata);
     end
    no_pkt++;
    end
  endtask
  
  task main;
   
   forever begin
    fork 
     begin
      wait(vif_fifo.reset);
     end
    
     begin
      drive();
     end
    join_any
    disable fork;
   end
  endtask
    
endclass
