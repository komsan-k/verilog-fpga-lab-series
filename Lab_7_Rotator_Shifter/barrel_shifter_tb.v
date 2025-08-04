module barrel_shifter_tb;
    reg [7:0] data_in;
    reg [2:0] shift_amt;
    reg dir;
    wire [7:0] data_out;

    barrel_shifter uut (.data_in(data_in), .shift_amt(shift_amt), .dir(dir), .data_out(data_out));

    initial begin
        $display("Input | Shift | Dir | Output");
        data_in = 8'b10110011;

        dir = 0; shift_amt = 3; #10;
        dir = 1; shift_amt = 2; #10;

        $finish;
    end
endmodule
