
module countdown_tb;

  // Parameters
  parameter COUNT_BITS = 8;

  //Ports
  reg clk;
  reg rst;
  reg enable;
  reg start;
  reg [COUNT_BITS-1:0] count_from;
  wire timeout;
  wire [COUNT_BITS-1:0] current_count;

  parameter CLK_FREQ = 100_000;  // 100 MHz

  wire tick;
  counter_1hz #(
      .CLK_FREQ(CLK_FREQ)
  ) counter_1hz_inst (
      .clk(clk),
      .rst(rst),
      .enable(enable),
      .tick(tick)
  );

  countdown #(
      .COUNT_BITS(COUNT_BITS)
  ) countdown_inst (
      .clk(clk),
      .tick(tick),
      .rst(rst),
      .enable(enable),
      .start(start),
      .count_from(count_from),
      .current_count(current_count),
      .timeout(timeout)
  );

  parameter CLK_PERIOD = 10;  // 100 MHz clk
  parameter TICK_PERIOD = CLK_PERIOD * CLK_FREQ;

  always #(CLK_PERIOD / 2) clk = !clk;

  parameter VCD_PATH = "./vcd/countdown_tb.vcd";

  initial begin
    $dumpfile(VCD_PATH);
    $dumpvars;
  end

  initial begin
    clk <= 0;
    rst <= 1;
    enable <= 1;
    start <= 0;
    count_from <= 10;
    #(CLK_PERIOD * 10);
    rst <= 0;
    #(CLK_PERIOD * 10);
    start <= 1;
    #(TICK_PERIOD * 3);
    start <= 0;
    #(TICK_PERIOD * 10);
    #(TICK_PERIOD * 3 / 4);
    rst <= 1;
    #(CLK_PERIOD * 10);
    rst <= 0;
    #(TICK_PERIOD * 3);
    start <= 1;
    #(TICK_PERIOD * 50);
    #(TICK_PERIOD / 4);
    count_from <= 20;
    #(TICK_PERIOD * 50);
    $finish;
  end

endmodule
