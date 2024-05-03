`timescale 1ns / 1ps

module counter_1hz_tb;

  // Parameters

  //Ports
  reg  clk;
  reg  rst;
  reg  enable;
  wire tick;

  parameter CLK_FREQ = 100_000;  // 100 MHz

  counter_1hz #(
      .CLK_FREQ(CLK_FREQ)
  ) counter_1hz_inst (
      .clk(clk),
      .rst(rst),
      .enable(enable),
      .tick(tick)
  );

  parameter CLK_PERIOD = 10;  // 100 MHz clk

  always #(CLK_PERIOD / 2) clk = !clk;

  parameter VCD_PATH = "./vcd/counter_1hz_tb.vcd";

  initial begin
    $dumpfile(VCD_PATH);
    $dumpvars;
  end

  initial begin
    clk <= 0;
    rst <= 1;
    enable <= 0;
    #(CLK_PERIOD * 10);
    rst <= 0;
    #(CLK_PERIOD * 20);
    enable <= 1;
    #(CLK_PERIOD * CLK_FREQ * 5);
    rst <= 1;
    #(CLK_PERIOD * CLK_FREQ / 2);
    rst <= 0;
    #(CLK_PERIOD * CLK_FREQ / 2);
    enable <= 0;
    #(CLK_PERIOD * CLK_FREQ * 5);
    $finish;
  end

endmodule
