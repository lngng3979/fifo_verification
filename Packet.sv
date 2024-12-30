`ifndef PACKET_SV
`define PACKET_SV
class packet;

bit resetn, clk;
rand bit [7:0] wdata; 
rand bit i_wreq, i_rreq;
bit [7:0] rdata;
bit fifo_isfull, fifo_isempty;
bit o_wready , o_rready ;

constraint wreq_rreq_en{i_wreq != i_rreq;};

endclass
`endif