module countdown #(
    parameter COUNT_BITS = 8
) (
    clk,
    tick,
    rst,
    enable,
    start,
    count_from,
    timeout,
    current_count
);
  // region module ports

  input clk;
  input wire tick;
  input wire rst;
  input wire enable;
  input wire start;
  input wire [COUNT_BITS-1:0] count_from;
  output wire timeout;
  output reg [COUNT_BITS-1:0] current_count;
  // endregion module ports

  // region module behavior
  // count
  reg [COUNT_BITS-1:0] next_count_from;
  assign timeout = (current_count == 0);

  always @(posedge tick or posedge rst) begin
    if (rst) current_count <= 0;
    else if (enable) begin
      if (timeout) current_count <= next_count_from;
      else current_count <= current_count - 1;
    end
  end

  // next count from
  always @(posedge clk or posedge rst) begin
    if (rst) next_count_from <= 0;
    if (start & enable) begin
      next_count_from <= count_from;
    end
  end
  // endregion module behavior

endmodule  //countdown
