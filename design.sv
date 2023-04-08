module my_mem(
  input clk,
  input write,
  input read,
  input [7:0] data_in,
  input [15:0] address,
  output reg [7:0] data_out
);

  reg [7:0] mem [0:65535]; // 2^16 bytes of memory
  
  always @(posedge clk) begin
    if (write) begin
      mem[address] <= data_in;
    end
    if (read) begin
      data_out <= mem[address];
    end
  end
  
endmodule
