module tb;
  parameter Addr_Width = 4;
  parameter Data_Width = 8;
  
  reg CLKA,CLKB,WENA,WENB;
  reg [Addr_Width-1:0] AA,AB;
  reg [Data_Width-1:0] DA,DB;
  wire [Data_Width-1:0] QA,QB;
  
  
  parameter CLK_PERIOD = 20;
  parameter WRITE_DLY = 10;
  parameter READ_DLY= 10;
  
  
  dual_port_ram DUT(.QA(QA),.QB(QB),.DA(DA),.DB(DB),.CLKA(CLKA),.CLKB(CLKB),.AA(AA),.AB(AB),.WENA(WENA),.WENB(WENB));
  
//clock generation CLKA, CLKB  
  always  #(CLK_PERIOD/2)  CLKA = ~ CLKA;
  always  #(CLK_PERIOD/2)  CLKB = ~ CLKB;
//always # 5 CLKA = ~CLKA; 
//always # 5 CLKB = ~CLKB;

// Task initialise 
 task initialize();
 begin
   CLKA = 0;
   CLKB = 0;
   WENA = 0;
   WENB = 0;
   AA = 0;
   AB = 0;
   DA = 0;
   DB = 0;
 end
 endtask
  
  

// Task write operation port 1
  task write_operation_port1;
    input [Addr_Width-1:0] address;
    input [Data_Width-1:0] data;
    
    begin
      @ (posedge CLKA)
      begin
        WENA = 1;
        AA <= address;
        DA <= data;   
        #(WRITE_DLY);  // Wait 
      end
    end
  endtask

// Task write operation port 2
  task write_operation_port2;
    input [Addr_Width-1:0] address;
    input [Data_Width-1:0] data;
    
    begin
      @ (posedge CLKB)
      begin
        WENB = 1;
        AB <= address;
        DB <= data;   
        #(WRITE_DLY);  // Wait
      end
    end
  endtask

// Task read operation port 1
  task read_operation_port1;
    input [Addr_Width-1:0] address;
    begin
      @ (posedge CLKA)
      begin
        WENA <= 0;
	    AA <= address;
      #(READ_DLY);
      //$display("READ :: Address:%0d  data: %0h",A,Dout);
	  end
	end
  endtask

// Task read operation port 2
  task read_operation_port2;
    input [Addr_Width-1:0] address;
    begin
      @ (posedge CLKB)
      begin
        WENB <= 0;
	    AB <= address;
      #(READ_DLY);
      //$display("READ :: Address:%0d  data: %0h",A,Dout);
	  end
	end
  endtask

  
  initial
    begin
      initialize();
      //repeat (3) begin
      	repeat (3) begin
            write_operation_port1($random, $random);
            write_operation_port2($random, $random);
        end

      	repeat (3) begin
            read_operation_port1($random);
            read_operation_port2($random);
        end
      //end
      $finish;
    end

  
  initial begin
   $dumpfile("dump.vcd");
   $dumpvars; 
   //#800 $finish;
end
    
endmodule
