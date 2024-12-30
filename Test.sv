`include "Enviroment.sv"
program test(fifo_if intf);
 enviroment env ;
  
  initial begin
    env = new(intf);
    env.gen.repeat_count = 10;
    env.run();
  end
endprogram
