`timescale 1ns / 1ns

module tb_my_mem;
  
  // define struct for transaction
  typedef struct  {
    logic [15:0] addr;
    logic [7:0] data;
    logic [8:0] expected_data;
    logic [8:0] actual_data;
  } transaction_t;
  
  // parameter values
  parameter CLK_PERIOD = 10;
  
  // DUT signals
  logic clk;
  logic write;
  logic read;
  logic [7:0] data_in;
  logic [15:0] address;
  logic [8:0] data_out;
  
  
  // testbench signals
  logic reset;
  transaction_t transactions [5:0];
  int error_count = 0;
 
  
  // DUT instance
  my_mem dut(clk, write, read, data_in, address, data_out);
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, tb_my_mem);
  end
  
  // reset generation
  initial begin
    reset = 1;
    clk = 0;
    #2 reset = 0;
  end
  
  // clock generation
  always #5ns clk = ~clk;
  
  // transaction generation
  initial begin
    // write transactions
    for (int i = 0; i < 6; i++) begin     
      // store transaction in array of structures
      transactions[i].addr = $random;
      transactions[i].data = $random;
      transactions[i].expected_data = {transactions[i].data[7:0], transactions[i].data[7:0]};
      
      // write data to memory
      write = 1;
      read = 0;
      address = transactions[i].addr;
      data_in = transactions[i].data;
      #CLK_PERIOD write = 0;
    end
    
    // shuffle array of structures to generate read transactions in a different order
     transactions.shuffle();
    
    // read transactions
    for (int i = 0; i < 6; i++) begin
      // read data from memory
      write = 0;
      read = 1;
      address = transactions[i].addr;
      #CLK_PERIOD transactions[i].actual_data = data_out;
      
      // check data read against expected data
      if (transactions[i].actual_data !== transactions[i].expected_data) begin
        error_count++;
        $display(": Data read does not match expected data at address %0h. Expected: %0h, Actual: %0h", 
                  transactions[i].addr, transactions[i].expected_data, transactions[i].actual_data);
      end
      
      // store data read in queue
      transactions[i].actual_data = data_out;
    end
    
    // print data read and error count
    $display("Data read:");
    for (int i = 0; i < 6; i++) begin
      $display("%0h: Expected: %0h, Actual: %0h", transactions[i].addr, transactions[i].expected_data, transactions[i].actual_data);
    end
    $display("Errors: %d", error_count);
  end
endmodule
