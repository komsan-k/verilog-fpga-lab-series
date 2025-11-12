
// -----------------------------------------------------------------------------
// Top-Level Traffic Light Controller for FPGA Board
// Includes 1 Hz tick divider and timer-based FSM for 2-way intersection
// -----------------------------------------------------------------------------

module tick_divider_pulse #(
    parameter integer CLK_HZ  = 100_000_000, // board clock frequency
    parameter integer TICK_HZ = 1            // desired tick rate (1 Hz)
)(
    input  wire clk,
    input  wire rst,
    output reg  tick_en
);
    localparam integer DIV = CLK_HZ / TICK_HZ;
    localparam integer W   = $clog2(DIV);
    reg [W-1:0] cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt    <= 0;
            tick_en <= 1'b0;
        end else begin
            if (cnt == DIV-1) begin
                cnt    <= 0;
                tick_en <= 1'b1;
            end else begin
                cnt    <= cnt + 1'b1;
                tick_en <= 1'b0;
            end
        end
    end
endmodule


// -----------------------------------------------------------------------------
// Traffic Light FSM (timer-driven, no side request)
// -----------------------------------------------------------------------------
module traffic_light_timer_tick #(
    parameter integer T_MAIN_GREEN  = 10,
    parameter integer T_MAIN_YELLOW = 3,
    parameter integer T_ALL_RED     = 1,
    parameter integer T_SIDE_GREEN  = 6,
    parameter integer T_SIDE_YELLOW = 3
)(
    input  wire clk,
    input  wire rst,
    input  wire tick_en,
    output reg  [2:0] lights_main,
    output reg  [2:0] lights_side
);
    localparam [2:0]
        S_MAIN_GREEN  = 3'd0,
        S_MAIN_YELLOW = 3'd1,
        S_ALL_RED_1   = 3'd2,
        S_SIDE_GREEN  = 3'd3,
        S_SIDE_YELLOW = 3'd4,
        S_ALL_RED_2   = 3'd5;

    reg [2:0] state, next_state;
    reg [7:0] timer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_MAIN_GREEN;
            timer <= T_MAIN_GREEN[7:0];
        end else if (tick_en) begin
            if (timer == 0) begin
                state <= next_state;
                case (next_state)
                    S_MAIN_GREEN:  timer <= T_MAIN_GREEN [7:0];
                    S_MAIN_YELLOW: timer <= T_MAIN_YELLOW[7:0];
                    S_ALL_RED_1:   timer <= T_ALL_RED     [7:0];
                    S_SIDE_GREEN:  timer <= T_SIDE_GREEN [7:0];
                    S_SIDE_YELLOW: timer <= T_SIDE_YELLOW[7:0];
                    S_ALL_RED_2:   timer <= T_ALL_RED     [7:0];
                    default:       timer <= T_MAIN_GREEN [7:0];
                endcase
            end else begin
                timer <= timer - 1'b1;
            end
        end
    end

    always @* begin
        lights_main = 3'b100;
        lights_side = 3'b100;
        next_state  = state;

        case (state)
            S_MAIN_GREEN:  begin lights_main = 3'b001; lights_side = 3'b100;
                            next_state = (timer==0) ? S_MAIN_YELLOW : S_MAIN_GREEN; end
            S_MAIN_YELLOW: begin lights_main = 3'b010; lights_side = 3'b100;
                            next_state = (timer==0) ? S_ALL_RED_1   : S_MAIN_YELLOW; end
            S_ALL_RED_1:   begin lights_main = 3'b100; lights_side = 3'b100;
                            next_state = (timer==0) ? S_SIDE_GREEN  : S_ALL_RED_1;   end
            S_SIDE_GREEN:  begin lights_main = 3'b100; lights_side = 3'b001;
                            next_state = (timer==0) ? S_SIDE_YELLOW : S_SIDE_GREEN;  end
            S_SIDE_YELLOW: begin lights_main = 3'b100; lights_side = 3'b010;
                            next_state = (timer==0) ? S_ALL_RED_2   : S_SIDE_YELLOW; end
            S_ALL_RED_2:   begin lights_main = 3'b100; lights_side = 3'b100;
                            next_state = (timer==0) ? S_MAIN_GREEN  : S_ALL_RED_2;   end
            default:       begin lights_main = 3'b100; lights_side = 3'b100;
                            next_state = S_MAIN_GREEN; end
        endcase
    end
endmodule


// -----------------------------------------------------------------------------
// Top-Level Module for FPGA Board (Nexys A7 example)
// -----------------------------------------------------------------------------
module top_traffic_light (
    input  wire clk_100mhz,
    input  wire rst,
    output wire [2:0] lights_main,
    output wire [2:0] lights_side
);
    wire tick_1hz;

    tick_divider_pulse #(
        .CLK_HZ(100_000_000),
        .TICK_HZ(1)
    ) u_tick (
        .clk(clk_100mhz),
        .rst(rst),
        .tick_en(tick_1hz)
    );

    traffic_light_timer_tick #(
        .T_MAIN_GREEN (10),
        .T_MAIN_YELLOW(3),
        .T_ALL_RED    (1),
        .T_SIDE_GREEN (6),
        .T_SIDE_YELLOW(3)
    ) u_ctrl (
        .clk(clk_100mhz),
        .rst(rst),
        .tick_en(tick_1hz),
        .lights_main(lights_main),
        .lights_side(lights_side)
    );
endmodule
