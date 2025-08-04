module mux_display (
    input clk,
    input rst,
    input [3:0] digit1,
    input [3:0] digit2,
    output reg [6:0] seg,
    output reg [3:0] an
);
    reg toggle;
    wire [6:0] seg1, seg2;

    seg_decoder dec1 (.digit(digit1), .seg(seg1));
    seg_decoder dec2 (.digit(digit2), .seg(seg2));

    reg [15:0] clkdiv;

    always @(posedge clk or posedge rst) begin
        if (rst)
            clkdiv <= 0;
        else
            clkdiv <= clkdiv + 1;
    end

    always @(posedge clkdiv[15]) begin
        toggle <= ~toggle;
    end

    always @(*) begin
        if (toggle) begin
            seg = seg1;
            an = 4'b1110; // Enable right digit
        end else begin
            seg = seg2;
            an = 4'b1101; // Enable left digit
        end
    end
endmodule
