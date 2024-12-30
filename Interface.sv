interface fifo_if(input logic clk, resetn);
    logic [7:0] wdata;
    logic i_rreq,i_wreq;
    logic [7:0] rdata;
    logic fifo_isempty, fifo_isfull, o_rready , o_wready;

    clocking driver_cb@(posedge clk);
        default input #1 output #1;
        output wdata;
        output i_rreq, i_wreq;
        input rdata;
        input fifo_isempty, fifo_isfull, o_rready, o_wready;

    endclocking

    clocking monitor_cb@(posedge clk);
    default input #1 output #1;
    input wdata;
    input i_rreq, i_wreq;
    input rdata;
    input fifo_isfull, fifo_isempty;
    input o_rready, o_wready;
    endclocking

    modport DRIVER(clocking driver_cb, input clk,resetn);
    modport MONITOR(clocking monitor_cb,input clk, resetn);
    
endinterface