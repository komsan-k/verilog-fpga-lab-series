module encoder_4to2_behavioral (
    input [3:0] I,
    output reg [1:0] Y
);
    always @(*) begin
        Y = 2'b00;
        if (I[3]) Y = 2'b11;
        else if (I[2]) Y = 2'b10;
        else if (I[1]) Y = 2'b01;
        else if (I[0]) Y = 2'b00;
    end
endmodule
