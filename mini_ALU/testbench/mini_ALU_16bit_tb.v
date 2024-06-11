// +FHDR----------------------------------------------------------------------------
//            
//                
// ---------------------------------------------------------------------------------
// Filename        : mini_ALU_16bit_tb.v
// Author          : xibei
// cinreated On    : 4024-06-07 13:30
// Last Modified   : 4024-06-09 11:30
// ---------------------------------------------------------------------------------
// Descinription   :  
//                   
//                               
// -FHDR----------------------------------------------------------------------------
`timescale 1ns/1ns
module mini_ALU_16bit_tb;
    reg clk;
    reg [15:0] data0;
    reg [15:0] data1;
    reg [7:0]   OP;
    reg        div_start;
    reg        rst;
    reg [4:0]  num_shift;

    wire [31:0] result;
    wire overflow;
    wire valid;
    
    mini_ALU_16bit tb(
        .clk(clk),
        .data0(data0),
        .data1(data1),
        .result(result),
        .OP(OP),
        .num_shift(num_shift),
        .overflow(overflow),
        .rst(rst),
        .valid(valid),
        .div_start(div_start)
    );


    initial clk=1'b0;
    always begin
        #5 clk=~clk;
    end
    initial begin
        data0=16'd0;data1=16'd0;OP=8'd0;num_shift=4'd0;div_start=1'b0;rst=1'b1;
    #20 rst=1'b0;
    #40 OP=8'd1;data0=16'd7387;data1=16'd37301;rst=1'b1;
    #40 OP=8'd1;data0=16'd37897;data1=16'd46644;
    
    #20 rst=1'b0;
    #40 OP=8'd2;data0=16'd7788;data1=16'd6677;rst=1'b1;
    #40 OP=8'd2;data0=16'd678; data1=16'd9658;
    
    #20 rst=1'b0;
    #40 OP=8'd3;data0=16'd6382;data1=16'd9134;rst=1'b1;
    #40 OP=8'd3;data0=16'd444;data1=16'd46666; 

        //and
    #20 rst=1'b0;
    #40 OP=8'd5;data0=16'heeff;data1=16'h0211;rst=1'b1;
    #40 OP=8'd5;data0=16'haaff;data1=16'h0121;
        //or
    #20 rst=1'b0;
    #40 OP=8'd6;data0=16'h51AB;data1=16'h2011;rst=1'b1;
    #40 OP=8'd6;data0=16'h21BB;data1=16'haa11;
        //xor
    #20 rst=1'b0;
    #40 OP=8'd7;data0=16'h7788;data1=16'haaaa;rst=1'b1;
    #40 OP=8'd7;data0=16'h6511;data1=16'h1122;
        //both_not
    #20 rst=1'b0;
    #40 OP=8'd8;data0=16'h1E22;data1=16'h22BB;rst=1'b1;
    #40 OP=8'd8;data0=16'h1111;data1=16'hFFFF;
        //data0_not
    #20 rst=1'b0;
    #40 OP=8'd9; data0=16'h14A2;data1=16'h5566;rst=1'b1;
    #40 OP=8'd9; data0=16'h1222;data1=16'h2116;
        //data1_not
    #20 rst=1'b0;
    #40 OP=8'd10; data0=16'h2222;data1=16'hCC11;rst=1'b1;
    #40 OP=8'd10; data0=16'h2222;data1=16'hCC11;
        //data0 left shift
    #20 rst=1'b0;
    #40 OP=8'd11;data0=16'h0e22;data1=16'h2222;num_shift=4'd3;rst=1'b1;
    #40 OP=8'd11;data0=16'haa10;data1=16'h1882;num_shift=4'd2;
        //data0 right
    #20 rst=1'b0;
    #40 OP=8'd12;data0=16'h1a30;data1=16'h2222;num_shift=4'd5;rst=1'b1;
    #40 OP=8'd12;data0=16'haa20;data1=16'h3333;num_shift=4'd7;
        //data1 left
    #20 rst=1'b0;
    #40 OP=8'd13;data0=16'h1111;data1=16'h23a2;num_shift=4'd3;rst=1'b1;
    #40 OP=8'd13;data0=16'ha567;data1=16'h1112;num_shift=4'd4;
            //data1 right
    #20 rst=1'b0;
    #40 OP=8'd14;data0=16'h2333;data1=16'h44a3;num_shift=4'd2;rst=1'b1;
    #40 OP=8'd14;data0=16'h7aaa;data1=16'h77aa;num_shift=4'd8;
        //CMP
    #20 rst=1'b0;
    #40 OP=8'd15; data0=16'd8773;data1=16'd9999;rst=1'b1;
    #40 OP=8'd15;data0=16'd1122;data1=16'd34;
    #40 OP=8'd15;data0=16'd2222;data1=16'd2222;
    //div
    #40 OP=8'd4;data0=16'd15;data1=16'd8;div_start=1'b0; rst=1'b0;
    #10 rst=1'b1;
    #10 div_start=1'b1;
    #10 div_start=1'b0;
    @valid
    #40 data0=10;data1=2;div_start = 1'b1;
    #10 div_start = 1'b0;
    @valid
    #40 data0=89;data1=21;div_start=1'b1;
    #10 div_start=1'b0;
    @valid
    #40 data0=0;data1=20;div_start=1'b1;
    #10 div_start=1'b0;
    @valid
    #40 data0=77;data1=0;div_start=1'b1;
    #10 div_start=1'b0;
    #200 $finish;
    end


    initial begin
        $dumpfile("mini_ALU_16bit_tb.vcd");
        $dumpvars(0,mini_ALU_16bit_tb);
end



endmodule