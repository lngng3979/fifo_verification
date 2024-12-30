`include "Packet.sv"
`define MONITOR_IF fifo_if.MONITOR.monitor_cb

class monitor ;
virtual fifo_if vif_fifo;
mailbox mon2scb ;

function new(virtual fifo_if vif_fifo, mailbox mon2scb);
    this.vif_fifo = vif_fifo;
    this.mon2scb = mon2scb;
endfunction

task main;
    
    forever begin
    packet pkt = new();

    @(posedge  `MONITOR_IF.clk);
    wait(`MONITOR_IF.i_rreq|| `MONITOR_IF.i_wreq);
    if(`MONITOR_IF.i_wreq)begin
        pkt.i_wreq = `MONITOR_IF.i_wreq ;
        pkt.wdata = `MONITOR_IF.wdata; 
        pkt.fifo_isfull = `MONITOR_IF.fifo_isfull;
        pkt.fifo_isempty = `MONITOR_IF.fifo_isempty;
        $display("\t ADDR= %0h \t DATA IN = %0h",pkt.i_wreq,pkt.wdata);
   end
    @(posedge `MONITOR_IF.clk);
   if(`MONITOR_IF.i_rreq)begin
    pkt.i_rreq = `MONITOR_IF.i_rreq ;
    @(posedge `MONITOR_IF.clk);
     pkt.rdata = `MONITOR_IF.rdata;
     pkt.fifo_isfull = `MONITOR_IF.fifo_isfull;
     pkt.fifo_isempty = `MONITOR_IF.fifo_isempty;
    $display("\t ADDR= %0h \t DATA IN = %0h",pkt.i_rreq,pkt.rdata);
   end
   mon2scb.put(pkt);
  end   
 endtask
endclass
