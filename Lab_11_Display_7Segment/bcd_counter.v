module bcd_counter (
    input clk,
    input rst,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ones <= 0;
            tens <= 0;
        end else begin
            if (ones == 9) begin
                ones <= 0;
                if (tens == 9)
                    tens <= 0;
                else
                    tens <= tens + 1;
            end else begin
                ones <= ones + 1;
            end
        end
    end
endmodule
