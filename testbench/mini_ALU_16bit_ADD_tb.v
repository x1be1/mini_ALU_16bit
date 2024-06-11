// +FHDR----------------------------------------------------------------------------
//            
//                
// ---------------------------------------------------------------------------------
// Filename        : mini_ALU_16bit_MUL_tb.v
// Author          : xibei
// cinreated On    : 2024-06-06 12:30
// Last Modified   : 2024-06-06 12:30
// ---------------------------------------------------------------------------------
// Descinription   :  
//                   
//                               
// -FHDR----------------------------------------------------------------------------
`timescale 1ns/1ns
module mini_ALU_16bit_ADD_tb;
    reg [15:0] data0;
    reg [15:0] data1;
    wire overflow;
    wire valid;
    wire [15:0] sum;


    mini_ALU_16bit_ADD tb(
        .data0(data0),
        .data1(data1),
        .overflow(overflow),
        .sum(sum),
        .valid(valid)
    );
    initial begin
            data0=15'd0;data1=15'd0;
    end

    initial begin
        #10 data0=15'd199; data1=15'd200;
        #10 data0=15'd20000;data1=15'd32000;
        #10 data0=15'd2897; data1=15'd8371;
    end
    always begin
        #10 data0=$random %65536; data1=$random %65536;
    end

    initial begin
        $monitor("Time: %t data0: %d data1: %d sum: %d overflow: %b",$time, data0, data1, sum, overflow);
end
    initial begin
        $dumpfile("mini_ALU_16bit_ADD_tb.vcd");
        $dumpvars(0,mini_ALU_16bit_ADD_tb);
end
endmodule