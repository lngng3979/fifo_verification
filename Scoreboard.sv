`include "Packet.sv"

class scoreboard;
mailbox mon2scb;
int no_pkt;
bit [7:0] ram [0:31];
bit write_pointer;
bit read_pointer;

function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
    foreach (ram[i]) begin 
        ram[i] = 8'hff;
    end
endfunction

task main;
   forever begin   
    packet pkt;
    #50
    mon2scb.get(pkt);
    if(pkt.i_wreq)begin
      ram[write_pointer] = pkt.wdata;
      write_pointer++;
    end  
    if(pkt.i_rreq)begin
      if(pkt.rdata == ram[read_pointer])begin
        read_pointer++;
        $display("yup");
      end
      else begin
        $display("nop");
      end
    end
    if(pkt.fifo_isfull)begin
      $display("fifo is full");
    end
    if(pkt.fifo_isempty)begin
      $display("fifo is empty");
    end
    no_pkt++;
   end
  endtask
endclass