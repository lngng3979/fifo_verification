module fifo(wdata, fifo_isempty, fifo_isfull, rdata, clk , resetn, o_wready, o_rready, i_rreq, i_wreq);

input [7:0] wdata;
input resetn, clk, i_rreq , i_wreq;
output reg [ 7:0] rdata;
output reg fifo_isempty, fifo_isfull, o_rready, o_wready;

reg [7:0] ram [31:0];

integer write_pointer;
integer read_pointer;
integer fifo_dcount;

always@(posedge clk )begin

    if (resetn) begin
                rdata<= 32'b0;
                write_pointer<= 1'b0;
                read_pointer<= 1'b0;
    end

    else if ((i_wreq) && (~fifo_isfull) && (~i_rreq)) begin
            ram[write_pointer] <= wdata;
            write_pointer = write_pointer +1;
            fifo_isempty <= 1'b0;
            
            if (write_pointer == read_pointer) begin
                fifo_isfull <= 1'b1;
                fifo_isempty <= 1'b0;
            end
    end

    else if ((i_rreq) && (~fifo_isempty) && (~i_wreq)) begin
            rdata <= ram[ read_pointer];
            read_pointer = read_pointer +1;
    if (write_pointer == read_pointer) begin
        fifo_isfull <= 1'b0;
        fifo_isempty <= 1'b1;
    end
    end
end
endmodule
