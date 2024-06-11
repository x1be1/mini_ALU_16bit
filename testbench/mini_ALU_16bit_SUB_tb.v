// +FHDR----------------------------------------------------------------------------
//            
//                
// ---------------------------------------------------------------------------------
// Filename        : mini_ALU_16bit_SUB_tb.v
// Author          : xibei
// cinreated On    : 2024-06-07 12:00
// Last Modified   : 2024-06-07 12:10
// ---------------------------------------------------------------------------------
// Descinription   :  
//                   
//                               
// -FHDR----------------------------------------------------------------------------
module mini_ALU_16bit_SUB_tb;
reg [15:0] data0;
reg [15:0] data1;
wire overflow;
wire [15:0] diff;
wire valid;

mini_ALU_16bit_SUB tb(
    .data0(data0),
    .data1(data1),
    .diff(diff),
    .overflow(overflow),
    .valid(valid)
);

initial begin
    data0=15'd0;data1=15'd0;
end

always begin
    #10 data0=$random %65536; data1=$random %65536;
end
initial begin
    $dumpfile("mini_ALU_16bit_SUB_tb.vcd");
    $dumpvars(0,mini_ALU_16bit_SUB_tb);
end
initial begin
$monitor("Time: %t data0: %d data1: %d diff: %d overflow: %b",$time, data0, data1, diff, overflow);
end

endmodule