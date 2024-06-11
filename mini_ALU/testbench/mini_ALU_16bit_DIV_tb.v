// +FHDR----------------------------------------------------------------------------
//            
//                
// ---------------------------------------------------------------------------------
// Filename        : mini_ALU_16bit_DIV_tb.v
// Author          : xibei
// cinreated On    : 2024-06-08 22:10
// Last Modified   : 2024-06-07 20:20
// ---------------------------------------------------------------------------------
// Descinription   :  
//                   
//                               
// -FHDR----------------------------------------------------------------------------
`timescale 1ns/1ns
module mini_ALU_16bit_DIV_tb;
reg clk,rst,start;
reg [15:0]X,Y;
wire [15:0]quot,rem;
wire valid;

always #5 clk = ~clk;

mini_ALU_16bit_DIV inst (
    .clk(clk),
    .rst(rst),
    .start(start),
    .X(X),
    .Y(Y),
    .valid(valid),
    .quot(quot),
    .rem(rem)
    );

initial
$monitor($time,"X=%d, Y=%d, valid=%d, quot=%d, rem=%d ",X,Y,valid,quot,rem);

initial
begin
X=15;Y=8;clk=1'b1;rst=1'b0;start=1'b0;
#10 rst = 1'b1;
#10 start = 1'b1;
#10 start = 1'b0;
@valid
#10 X=10;Y=2;start = 1'b1;
#10 start = 1'b0;
@valid
#10 X=89;Y=21;start=1'b1;
#10 start=1'b0;
@valid
#10 X=0;Y=20;start=1'b1;
#10 start=1'b0;
@valid
#10 X=77;Y=0;start=1'b1;
#10 start=1'b0;
end      
    initial begin
        $dumpfile("mini_ALU_16bit_DIV_tb.vcd");
        $dumpvars(0,mini_ALU_16bit_DIV_tb);
end
endmodule