module traffic_light_fsm (
    input clk,
    input rst,
    output reg [2:0] lights  // {Red, Yellow, Green}
);
    typedef enum reg [1:0] {S0, S1, S2} state_t;
    state_t current_state, next_state;
    reg [3:0] timer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S0;
            timer <= 0;
        end else begin
            if (timer == 0) begin
                current_state <= next_state;
                case (next_state)
                    S0: timer <= 5;
                    S1: timer <= 2;
                    S2: timer <= 5;
                endcase
            end else begin
                timer <= timer - 1;
            end
        end
    end

    always @(*) begin
        case (current_state)
            S0: begin lights = 3'b001; next_state = S1; end // Green
            S1: begin lights = 3'b010; next_state = S2; end // Yellow
            S2: begin lights = 3'b100; next_state = S0; end // Red
            default: begin lights = 3'b000; next_state = S0; end
        endcase
    end
endmodule
