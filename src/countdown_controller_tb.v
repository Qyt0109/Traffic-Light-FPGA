`timescale 1ns / 1ps

module countdown_controller_tb;

  // Parameters
  parameter CLK_FREQ = 100_000;
  parameter COUNT_BITS = 4;
  parameter T = 10;
  parameter t = 3;

  //Ports
  reg clk;
  reg rst;
  reg car;
  wire [COUNT_BITS-1:0] current_count;
  wire [2:0] highway_gry;
  wire [2:0] country_gry;

  countdown_controller #(
      .CLK_FREQ(CLK_FREQ),
      .COUNT_BITS(COUNT_BITS),
      .T(T),
      .t(t)
  ) countdown_controller_inst (
      .clk(clk),
      .rst(rst),
      .car(car),
      .current_count(current_count),
      .highway_gry(highway_gry),
      .country_gry(country_gry)
  );

  parameter CLK_PERIOD = 10;  // 100 MHz clk
  parameter TICK_PERIOD = CLK_PERIOD * CLK_FREQ;

  always #(CLK_PERIOD / 2) clk = !clk;

  parameter VCD_PATH = "./vcd/countdown_controller_tb.vcd";

  initial begin
    $dumpfile(VCD_PATH);
    $dumpvars;
  end

  initial begin
    clk <= 0;
    rst <= 1;
    car <= 0;
    #(CLK_FREQ * 10);
    rst <= 0;

    #(TICK_PERIOD * 30);
    car <= 1;

    #(TICK_PERIOD * 100);
    $finish;
  end

endmodule
