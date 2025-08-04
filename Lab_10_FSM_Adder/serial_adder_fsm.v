module serial_adder_fsm (
    input clk,
    input rst,
    input start,
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] SUM,
    output reg done
);
    reg [2:0] bit_cnt;
    reg carry;
    reg [3:0] regA, regB;
    reg [1:0] state;

    localparam IDLE = 2'b00,
               LOAD = 2'b01,
               ADD  = 2'b10,
               DONE = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= IDLE;
            SUM     <= 0;
            carry   <= 0;
            done    <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= LOAD;
                end
                LOAD: begin
                    regA <= A;
                    regB <= B;
                    bit_cnt <= 0;
                    SUM <= 0;
                    carry <= 0;
                    state <= ADD;
                end
                ADD: begin
                    {carry, SUM[bit_cnt]} <= regA[bit_cnt] + regB[bit_cnt] + carry;
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 3)
                        state <= DONE;
                end
                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

