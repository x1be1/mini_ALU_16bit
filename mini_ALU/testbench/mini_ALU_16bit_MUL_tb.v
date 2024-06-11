// +FHDR----------------------------------------------------------------------------
//            
//                
// ---------------------------------------------------------------------------------
// Filename        : mini_ALU_16bit_MUL_tb.v
// Author          : xibei
// cinreated On    : 2024-06-07 10:30
// Last Modified   : 2024-06-08 23:30
// ---------------------------------------------------------------------------------
// Descinription   :  
//                   
//                               
// -FHDR----------------------------------------------------------------------------
`timescale 1ns/1ns
module mini_ALU_16bit_MUL_tb;
    reg [15:0] data0;
    reg [15:0] data1;
    wire [31:0] product;
    wire overflow;
    wire valid;

    mini_ALU_16bit_MUL tb(
        .data0(data0),
        .data1(data1),
        .product(product),
        .overflow(overflow),
        .valid(valid)
    );

    initial begin
        data0=16'd0;data1=16'd0;
    end

    always begin
        #20 data0=$random %65536; data1=$random %65536;
    end
    initial begin
        $dumpfile("mini_ALU_16bit_MUL_tb.vcd");
        $dumpvars(0,mini_ALU_16bit_MUL_tb);
end
initial begin
    $monitor("Time: %t data0: %d data1: %d product: %d ",$time, data0, data1, product);
end

endmodule