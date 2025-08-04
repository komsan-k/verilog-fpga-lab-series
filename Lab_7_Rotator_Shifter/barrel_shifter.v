module barrel_shifter (
    input [7:0] data_in,
    input [2:0] shift_amt,   //  shift amount (0-7)
    input dir,               // 0 = left, 1 = right
    output reg [7:0] data_out
);
    always @(*) begin
        if (dir == 1'b0)
            data_out = data_in << shift_amt; // Logical left shift
        else
            data_out = data_in >> shift_amt; // Logical right shift
    end
endmodule
