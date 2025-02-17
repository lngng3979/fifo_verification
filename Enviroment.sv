`include "Generator.sv"
`include "Driver.sv"
`include "Monitor.sv"
`include "Scoreboard.sv"
class enviroment;
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  mailbox gen2drv;
  mailbox mon2scb;
  
  event drv2gen;//to show generation of signals have stopped
  virtual fifo_if vif_fifo;
  
  function new(virtual fifo_if vif_fifo);
    this.vif_fifo = vif_fifo;
    gen2drv = new();
    mon2scb = new();
    gen = new(gen2drv,drv2gen);
    drv = new(vif_fifo,gen2drv);
    mon = new(vif_fifo,mon2scb);
    scb = new(mon2scb);
  endfunction
  
  task pre_test();
   drv.reset();
  endtask
  
  task test();
   gen.main();
   drv.main();
   mon.main();
   scb.main();
  endtask
  
  task post_test();
   wait(drv2gen.triggered);
   wait(gen.repeat_count == drv.no_pkt);
   wait(gen.repeat_count == scb.no_pkt);
  endtask
  
  task run();
   pre_test();
   test();
   post_test();
   $finish;
  endtask
endclass
