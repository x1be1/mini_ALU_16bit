// +FHDR----------------------------------------------------------------------------
//            
//                
// ---------------------------------------------------------------------------------
// Filename        : mini_ALU_16bit_ADD.v
// Author          : xibei
// cinreated On    : 2024-06-06 10:30
// Last Modified   : 2024-06-06 11:00
// ---------------------------------------------------------------------------------
// Descinription   :  普通串行加法器，溢出值无效
//                   
//                               
// -FHDR----------------------------------------------------------------------------
module mini_ALU_16bit_ADD(
    input [15:0] data0,
    input [15:0] data1,
    output [15:0] sum,
    output overflow,
    output valid
);
    wire [15:0] carry;


                    full_adder fa0(
                        .data0(data0[0]),
                        .data1(data1[0]),
                        .cin(1'b0),
                        .sum(sum[0]),
                        .cout(carry[0])
                    );                    
                    full_adder fa15(
                        .data0(data0[15]),
                        .data1(data1[15]),
                        .cin(carry[14]),
                        .sum(sum[15]),
                        .cout(overflow)
                    );
    generate
        genvar i;
            for(i=1;i<15;i=i+1)begin:fadd
                    full_adder fa(
                        .data0(data0[i]),
                        .data1(data1[i]),
                        .cin(carry[i-1]),
                        .sum(sum[i]),
                        .cout(carry[i])
                    );
                end


    endgenerate
    
    assign valid=(overflow==1)?1'b0:1'b1;

endmodule

module full_adder( 
    input data0,
    input data1,
    input cin,
    output sum,
    output cout
);

    assign sum=data0^data1^cin;
    assign cout=(data0&data1) | (data0&cin) | (data1&cin);

endmodule