module clock_divider #(parameter N = 25) (
    input clk_in,
    input rst,
    output reg clk_out
);
    reg [N-1:0] count;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else begin
            count <= count + 1;
            clk_out <= count[N-1];
        end
    end
endmodule
