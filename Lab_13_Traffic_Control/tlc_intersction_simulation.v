
module traffic_light_timer #(
    parameter integer T_MAIN_GREEN  = 10, // ticks
    parameter integer T_MAIN_YELLOW = 3,
    parameter integer T_ALL_RED     = 1,
    parameter integer T_SIDE_GREEN  = 6,
    parameter integer T_SIDE_YELLOW = 3
)(
    input  wire clk,
    input  wire rst,
    output reg  [2:0] lights_main, // {R,Y,G}
    output reg  [2:0] lights_side  // {R,Y,G}
);

    // ------------------------
    // States
    // ------------------------
    localparam [2:0]
        S_MAIN_GREEN  = 3'd0,
        S_MAIN_YELLOW = 3'd1,
        S_ALL_RED_1   = 3'd2, // after Main → before Side
        S_SIDE_GREEN  = 3'd3,
        S_SIDE_YELLOW = 3'd4,
        S_ALL_RED_2   = 3'd5; // after Side → before Main

    reg [2:0] state, next_state;
    reg [7:0] timer;

    // ------------------------
    // Sequential
    // ------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_MAIN_GREEN;
            timer <= T_MAIN_GREEN[7:0];
        end else begin
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

    // ------------------------
    // Combinational
    // ------------------------
    always @* begin
        lights_main = 3'b100; // R
        lights_side = 3'b100; // R
        next_state  = state;

        case (state)
            S_MAIN_GREEN: begin
                lights_main = 3'b001; // G
                lights_side = 3'b100; // R
                next_state  = (timer == 0) ? S_MAIN_YELLOW : S_MAIN_GREEN;
            end
            S_MAIN_YELLOW: begin
                lights_main = 3'b010; // Y
                lights_side = 3'b100; // R
                next_state  = (timer == 0) ? S_ALL_RED_1 : S_MAIN_YELLOW;
            end
            S_ALL_RED_1: begin
                lights_main = 3'b100; // R
                lights_side = 3'b100; // R
                next_state  = (timer == 0) ? S_SIDE_GREEN : S_ALL_RED_1;
            end
            S_SIDE_GREEN: begin
                lights_main = 3'b100; // R
                lights_side = 3'b001; // G
                next_state  = (timer == 0) ? S_SIDE_YELLOW : S_SIDE_GREEN;
            end
            S_SIDE_YELLOW: begin
                lights_main = 3'b100; // R
                lights_side = 3'b010; // Y
                next_state  = (timer == 0) ? S_ALL_RED_2 : S_SIDE_YELLOW;
            end
            S_ALL_RED_2: begin
                lights_main = 3'b100; // R
                lights_side = 3'b100; // R
                next_state  = (timer == 0) ? S_MAIN_GREEN : S_ALL_RED_2;
            end
            default: begin
                lights_main = 3'b100;
                lights_side = 3'b100;
                next_state  = S_MAIN_GREEN;
            end
        endcase
    end
endmodule
