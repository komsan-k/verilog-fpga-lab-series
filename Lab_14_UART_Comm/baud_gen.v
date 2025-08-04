module baud_gen (
    input clk,
    input rst,
    output reg tick
);
    parameter BAUD_DIV = 10416; // 100MHz / 9600

    reg [13:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            tick <= 0;
        end else begin
            if (count == BAUD_DIV - 1) begin
                count <= 0;
                tick <= 1;
            end else begin
                count <= count + 1;
                tick <= 0;
            end
        end
    end
endmodule

