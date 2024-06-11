// +FHDR----------------------------------------------------------------------------
//            
//                
// ---------------------------------------------------------------------------------
// Filename        : mini_ALU_16bit_SUB_tb.v
// Author          : xibei
// cinreated On    : 2024-06-06 11:30
// Last Modified   : 2024-06-08 23:20
// ---------------------------------------------------------------------------------
// Descinription   :  被减数小时，取绝对值，overflow标志1
//                
//                               
// -FHDR----------------------------------------------------------------------------
module mini_ALU_16bit_SUB(
    input [15:0] data0,//减数
    input [15:0] data1, //被减数
    output [15:0] diff,
    output overflow,
    output valid
);
    wire [15:0] data1_complement;
    assign data1_complement=~data1+1'b1;

    wire [15:0] result_register;
    mini_ALU_16bit_ADD SUB(
            .data0(data0),
            .data1(data1_complement),
            .sum(result_register),
            .cout()
    );

    assign diff=(data0<data1)?(~result_register+1'b1):result_register;

    assign overflow=(data0<data1)?1'b1:1'b0;
    assign valid=(data0<data1)?1'b0:1'b1;


endmodule


module mini_ALU_16bit_ADD(
    input [15:0] data0,
    input [15:0] data1,
    output [15:0] sum,
    output cout
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
                        .cout(cout)
                    );
    generate
        genvar i;
            for(i=1;i<15;i=i+1)begin:fadd_sub
                    full_adder fa(
                        .data0(data0[i]),
                        .data1(data1[i]),
                        .cin(carry[i-1]),
                        .sum(sum[i]),
                        .cout(carry[i])
                    );
                end

    endgenerate

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