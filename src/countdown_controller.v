module countdown_controller #(
    parameter CLK_FREQ = 50_000,
    parameter COUNT_BITS = 8,
    parameter T = 10,
    parameter t = 3
) (
    clk,
    rst,
    car,
    current_count,
    highway_gry,
    country_gry
);
  // region module ports
  input wire clk;
  input wire rst;
  input wire car;
  output wire [COUNT_BITS-1:0] current_count;
  output reg [2:0] highway_gry;
  output reg [2:0] country_gry;
  // endregion module ports

  // region counter_1hz
  wire tick;
  counter_1hz #(
      .CLK_FREQ(CLK_FREQ)
  ) counter_1hz_inst (
      .clk(clk),
      .rst(rst),
      .enable(enable),
      .tick(tick)
  );
  // endregion counter_1hz

  // region countdown
  reg enable = 1;
  reg start = 1;
  reg [COUNT_BITS-1:0] count_from;
  wire timeout;
  countdown #(
      .COUNT_BITS(COUNT_BITS)
  ) countdown_inst (
      .clk(clk),
      .tick(tick),
      .rst(rst),
      .enable(enable),
      .start(start),
      .count_from(count_from),
      .timeout(timeout),
      .current_count(current_count)
  );
  // endregion countdown

  // region fsm
  parameter GR = 4'b0001;
  parameter YR = 4'b0010;
  parameter RG = 4'b0100;
  parameter RY = 4'b1000;
  reg [3:0] current_state;
  reg [3:0] next_state;

  parameter GREEN = 3'b100;
  parameter RED = 3'b010;
  parameter YELLOW = 3'b001;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      next_state <= GR;
      {highway_gry, country_gry} = {GREEN, RED};
    end else begin
      case (current_state)
        GR: begin
          {highway_gry, country_gry} = {GREEN, RED};
          if (car & timeout) begin
            next_state <= YR;
          end
        end
        YR: begin
          {highway_gry, country_gry} = {YELLOW, RED};
          if (timeout) begin
            next_state <= RG;
          end
        end
        RG: begin
          {highway_gry, country_gry} = {RED, GREEN};
          if (timeout) begin
            next_state <= RY;
          end
        end
        RY: begin
          {highway_gry, country_gry} = {RED, YELLOW};
          if (timeout) begin
            next_state <= GR;
          end
        end
        default: begin
          next_state <= GR;
        end
      endcase
    end
  end

  always @(next_state) begin
    case (next_state)
      GR: begin
        count_from <= T;
      end
      YR: begin
        count_from <= t;
      end
      RG: begin
        count_from <= T;
      end
      RY: begin
        count_from <= t;
      end
      default: begin
        count_from <= T;
      end
    endcase
  end

  always @(posedge tick or posedge rst) begin
    if (rst) begin
      current_state <= GR;
    end else begin
      current_state <= next_state;
    end

  end
  // endregion fsm


endmodule  //countdown_controller
