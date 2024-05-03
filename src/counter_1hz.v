module counter_1hz #(
    parameter CLK_FREQ = 50_000
) (
    clk,
    rst,
    enable,
    tick
);

  // region module ports
  input wire clk;
  input wire rst;
  input wire enable;
  output wire tick;
  // endregion module ports

  // region module behavior
  parameter COUNTER_BITS = $clog2(CLK_FREQ);
  reg [COUNTER_BITS-1:0] r_count;

  assign tick = (r_count == (CLK_FREQ - 1));

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      r_count <= 0;
    end else if (enable) begin
      if (tick) r_count <= 0;
      else r_count <= r_count + 1;
    end
  end
  // endregion module behavior

endmodule  //counter_1hz
