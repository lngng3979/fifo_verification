`include "Packet.sv"
class generator;
    rand packet pkt;
    mailbox gen2drv;
    int repeat_count;
    event drv2gen;

    function new( mailbox gen2drv , event drv2gen);
            this.gen2drv = gen2drv;
            this.drv2gen = drv2gen;
    endfunction

    task main();
    repeat(repeat_count) begin
        pkt = new();
        if(!pkt.randomize()) $fatal("Gen :: pkt randomization failed ");
         gen2drv.put(pkt);
    end
    ->drv2gen;
    endtask
endclass