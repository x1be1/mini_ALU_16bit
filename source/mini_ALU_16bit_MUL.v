// +FHDR----------------------------------------------------------------------------
//            
//                
// ---------------------------------------------------------------------------------
// Filename        : mini_ALU_16bit_MUL.v
// Author          : xibei
// cinreated On    : 2024-06-07 18:30
// Last Modified   : 2024-06-08 20:30
// ---------------------------------------------------------------------------------
// Descinription   :  纯模拟手算，优化可对部分积使用压缩器进行压缩wallace
//                    若有符号也可先采用booth编码进行优化编码，再进行部分积
//                    压缩              
// -FHDR----------------------------------------------------------------------------
module mini_ALU_16bit_MUL (
    input [15:0] data0,
    input [15:0] data1,
    output [31:0]  product,
    output overflow,
    output valid
);

    wire [30:0] partial_product [15:0];
    wire [30:0] tem_partial_product [14:0];


    //部分积
    assign partial_product[0] ={{15{1'b0}} , data0 & {16{data1[0]}}              };
    assign partial_product[1] ={{14{1'b0}} , data0 & {16{data1[1]}} ,  1'b0      };
    assign partial_product[2] ={{13{1'b0}} , data0 & {16{data1[2]}} ,  2'b00     };
    assign partial_product[3] ={{12{1'b0}} , data0 & {16{data1[3]}} ,  3'b000    };
    assign partial_product[4] ={{11{1'b0}} , data0 & {16{data1[4]}} , {4{1'b0}}  };
    assign partial_product[5] ={{10{1'b0}} , data0 & {16{data1[5]}} , {5{1'b0}}  };
    assign partial_product[6] ={{ 9{1'b0}} , data0 & {16{data1[6]}} , {6{1'b0}}  };
    assign partial_product[7] ={{ 8{1'b0}} , data0 & {16{data1[7]}} , {7{1'b0}}  };
    assign partial_product[8] ={{ 7{1'b0}} , data0 & {16{data1[8]}} , {8{1'b0}}  };
    assign partial_product[9] ={{ 6{1'b0}} , data0 & {16{data1[9]}} , {9{1'b0}}  };
    assign partial_product[10]={{ 5{1'b0}} , data0 & {16{data1[10]}},{10{1'b0}}  };
    assign partial_product[11]={{ 4{1'b0}} , data0 & {16{data1[11]}},{11{1'b0}}  };
    assign partial_product[12]={{ 3{1'b0}} , data0 & {16{data1[12]}},{12{1'b0}}  };
    assign partial_product[13]={{ 2{1'b0}} , data0 & {16{data1[13]}},{13{1'b0}}  };
    assign partial_product[14]={    1'b0   , data0 & {16{data1[14]}},{14{1'b0}}  };
    assign partial_product[15]={data0 & {16{data1[15]}},             {15{1'b0}}  };

    wire [14:0] temp_cout;
    adder_31bit a0(
        .a(partial_product[0]),
        .b(partial_product[1]),
        .sum(tem_partial_product[0]),
        .cout(temp_cout[0]),
        .cin(1'b0)
    );
    adder_31bit a1(
        .a(tem_partial_product[0]),
        .b(partial_product[2]),
        .sum(tem_partial_product[1]),
        .cout(temp_cout[1]),
        .cin(temp_cout[0])
    );
    adder_31bit a2(
        .a(tem_partial_product[1]),
        .b(partial_product[3]),
        .sum(tem_partial_product[2]),
        .cout(temp_cout[2]),
        .cin(temp_cout[1])
    );
    adder_31bit a3(
        .a(tem_partial_product[2]),
        .b(partial_product[4]),
        .sum(tem_partial_product[3]),
        .cout(temp_cout[3]),
        .cin(temp_cout[2])
    );
    adder_31bit a4(
        .a(tem_partial_product[3]),
        .b(partial_product[5]),
        .sum(tem_partial_product[4]),
        .cout(temp_cout[4]),
        .cin(temp_cout[3])
    );
    adder_31bit a5(
        .a(tem_partial_product[4]),
        .b(partial_product[6]),
        .sum(tem_partial_product[5]),
        .cout(temp_cout[5]),
        .cin(temp_cout[4])
    );
    adder_31bit a6(
        .a(tem_partial_product[5]),
        .b(partial_product[7]),
        .sum(tem_partial_product[6]),
        .cout(temp_cout[6]),
        .cin(temp_cout[5])
    );
    adder_31bit a7(
        .a(tem_partial_product[6]),
        .b(partial_product[8]),
        .sum(tem_partial_product[7]),
        .cout(temp_cout[7]),
        .cin(temp_cout[6])
    );
    adder_31bit a8(
        .a(tem_partial_product[7]),
        .b(partial_product[9]),
        .sum(tem_partial_product[8]),
        .cout(temp_cout[8]),
        .cin(temp_cout[7])
    );
    adder_31bit a9(
        .a(tem_partial_product[8]),
        .b(partial_product[10]),
        .sum(tem_partial_product[9]),
        .cout(temp_cout[9]),
        .cin(temp_cout[8])
    );
    adder_31bit a10(
        .a(tem_partial_product[9]),
        .b(partial_product[11]),
        .sum(tem_partial_product[10]),
        .cout(temp_cout[10]),
        .cin(temp_cout[9])
    );
    adder_31bit a11(
        .a(tem_partial_product[10]),
        .b(partial_product[12]),
        .sum(tem_partial_product[11]),
        .cout(temp_cout[11]),
        .cin(temp_cout[10])
    );
    adder_31bit a12(
        .a(tem_partial_product[11]),
        .b(partial_product[13]),
        .sum(tem_partial_product[12]),
        .cout(temp_cout[12]),
        .cin(temp_cout[11])
    );
    adder_31bit a13(
        .a(tem_partial_product[12]),
        .b(partial_product[14]),
        .sum(tem_partial_product[13]),
        .cout(temp_cout[13]),
        .cin(temp_cout[12])
    );
    adder_31bit a14(
        .a(tem_partial_product[13]),
        .b(partial_product[15]),
        .sum(tem_partial_product[14]),
        .cout(temp_cout[14]),
        .cin(temp_cout[13])
    );
    
    assign product={temp_cout[14],tem_partial_product[14]};
    assign overflow=1'b0;
    assign valid=1'b1;
    

endmodule
//31bit全加器
module adder_31bit(
    input [30:0] a,
    input cin,
    input [30:0] b,
    output [30:0] sum,
    output  cout
);
    wire [30:0] carry;

    full_adder_mul fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );                    
    full_adder_mul fa15(
        .a(a[30]),
        .b(b[30]),
        .cin(carry[29]),
        .sum(sum[30]),
        .cout(cout)
    );
    generate
        genvar i;
            for(i=1;i<30;i=i+1)begin:fadd_31
                full_adder_mul fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
end
endgenerate

endmodule

//全加器
module full_adder_mul(
    input a,b,cin,
    output sum,cout
);
    assign  sum=a^b^cin;
    assign cout=a&b | ((a^b)&cin);


endmodule