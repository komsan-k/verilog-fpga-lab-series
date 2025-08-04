module seq_multiplier_4bit (
    input clk,
    input rst,
    input start,
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] product,
    output reg done
);
    reg [3:0] count;
    reg [3:0] multiplicand, multiplier;
    reg [7:0] temp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0; temp <= 0;
            done <= 0; product <= 0;
        end else if (start && !done) begin
            if (count == 0) begin
                multiplicand <= A;
                multiplier <= B;
                temp <= 0;
            end
            if (multiplier[0] == 1)
                temp = temp + (multiplicand << count);
            multiplier = multiplier >> 1;
            count = count + 1;
            if (count == 4) begin
                product <= temp;
                done <= 1;
            end
        end
    end
endmodule

