// +FHDR----------------------------------------------------------------------------
//            
//                
// ---------------------------------------------------------------------------------
// Filename        : mini_ALU_16bit.v
// Author          : xibei
// cinreated On    : 2024-06-05 13:30
// Last Modified   : 2024-06-09 11:30
// ---------------------------------------------------------------------------------
// Descinription   :  
//                   
//                               
// -FHDR----------------------------------------------------------------------------
module mini_ALU_16bit(
    input  [15:0]      data0,
    input  [15:0]      data1,
    input              div_start,
    input              clk,
    input              rst,
    input  [ 4:0]      num_shift,
    input  [ 7:0]      OP,
    output [31:0]      result,
    output    reg      overflow,
    output    reg      valid
    
);
    localparam ADD = 8'b0000_0001 ;  
    localparam SUB = 8'b0000_0010 ;
    localparam MUL = 8'b0000_0011 ;
    localparam DIV = 8'b0000_0100 ;
    localparam AND = 8'b0000_0101 ;
    localparam OR  = 8'b0000_0110 ;
    localparam XOR = 8'b0000_0111 ;
    localparam both_NOT = 8'b0000_1000 ;
    localparam data0_NOT = 8'b0000_1001 ;
    localparam data1_NOT = 8'b0000_1010 ;
    localparam data0_SHIFT_LEFT = 8'b0000_1011 ;
    localparam data1_SHIFT_RIGHT = 8'b0000_1100;
    localparam data0_SHIFT_RIGHT = 8'b0000_1101;
    localparam data1_SHIFT_LEFT =   8'b0000_1110;
    localparam CMP = 8'b0000_1111;

    reg [31:0] register;
    wire [3:0] temp_overflow;
    wire [3:0] temp_valid;

    wire [15:0] result_add;
    wire [15:0] result_sub;
    wire [31:0] result_mul;
    wire [15:0] result_quot;
    wire [15:0] result_rem;

    mini_ALU_16bit_ADD add(
        .data0(data0),
        .data1(data1),
        .sum(result_add),
        .overflow(temp_overflow[0]),
        .valid(temp_valid[0])
    );

    mini_ALU_16bit_SUB sub(
        .data0(data0),
        .data1(data1),
        .diff(result_sub),
        .overflow(temp_overflow[1]),
        .valid(temp_valid[1])
    );
    mini_ALU_16bit_MUL mul(
        .data0(data0),
        .data1(data1),
        .product(result_mul),
        .overflow(temp_overflow[2]),
        .valid(temp_valid[2])

    );

    mini_ALU_16bit_DIV div(
        .clk(clk),
        .rst(rst),
        .start(div_start),
        .X(data0),
        .Y(data1),
        .quot(result_quot),
        .rem(result_rem),
        .valid(temp_valid[3]),
        .overflow(temp_overflow[3])
);
        
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            register<=32'd0;
            overflow<=1'b0;
            valid<=1'b0;
        end
        else begin
            case (OP) 
                ADD: begin
                        register<={{16{1'b0}},result_add};
                        overflow<=temp_overflow[0];
                        valid<=temp_valid[0];
                    end
                SUB: begin
                        register<={{16{1'b0}},result_sub};
                        overflow<=temp_overflow[1];
                        valid<=temp_valid[1];
                end
                MUL: begin
                        register<=result_mul;
                        overflow<=temp_overflow[2];
                        valid<=temp_valid[2];
                end
                DIV: begin
                        register<={result_quot,result_rem};
                        overflow<=temp_overflow[3];
                        valid<=temp_valid[3];
                end
        
                AND: begin
                    register<= {{16{1'b0}},(data0 & data1)};
                    overflow<=1'b0;
                    valid<=1'b1;
                end
                OR: begin
                    register<= {{16{1'b0}},(data0 | data1)};
                    overflow<=1'b0;
                    valid<=1'b1;
                end 
                XOR: begin
                    register<= {{16{1'b0}},(data0 ^ data1)};
                    overflow<=1'b0;
                    valid<=1'b1;
                end
                both_NOT: begin
                    register <= { ~ data1 , ~ data0 };
                    overflow<=1'b0;
                    valid<=1'b1;
                end
                data0_NOT: begin
                    register <={{16{1'b0}},~data0};
                    overflow<=1'b0;
                    valid<=1'b1;
                end
                data1_NOT: begin 
                    register<={~data1,{16{1'b0}}};
                    overflow<=1'b0;
                    valid<=1'b1;
                end
                data0_SHIFT_LEFT: begin
                    register<=data0<<num_shift;
                    overflow<=1'b0;
                    valid<=1'b1;
                end
                data0_SHIFT_RIGHT: begin
                    register<=data0>>num_shift;
                    overflow<=1'b0;
                    valid<=1'b1;
                end
                data1_SHIFT_LEFT: begin
                    register<=data1<<num_shift;
                    overflow<=1'b0;
                    valid<=1'b1;
                end
                data1_SHIFT_RIGHT:begin 
                    register<=data1>>num_shift;
                    overflow<=1'b0;
                    valid<=1'b1;
                end
                CMP: begin
                    if(data0>data1) begin
                        register<=32'd1;
                        overflow<=1'b0;
                        valid<=1'b1;
                    end
                    else if(data0<data1) begin
                        register<=32'd2;
                        overflow<=1'b0;
                        valid<=1'b1;
                    end
                    else begin
                        register<=32'd3;
                        overflow<=1'b0;
                        valid<=1'b1;
			
                    end
                end
                default : begin
                        register<=32'd0;
                        overflow<=1'b1;
                        valid<=1'b0;
                end
            endcase
        end
    end

    assign result=register;

endmodule

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
    mini_ALU_16bit_ADD sub(
            .data0(data0),
            .data1(data1_complement),
            .sum(result_register),
            .overflow(),
            .valid()
    );

    assign diff=(data0<data1)?(~result_register+1'b1):result_register;

    assign overflow=(data0<data1)?1'b1:1'b0;
    assign valid=(data0<data1)?1'b0:1'b1;


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
    //cout置空
    adder_31bit a0(
        .a(partial_product[0]),
        .b(partial_product[1]),
        .sum(tem_partial_product[0]),
        .cout()
    );
    adder_31bit a1(
        .a(tem_partial_product[0]),
        .b(partial_product[2]),
        .sum(tem_partial_product[1]),
        .cout()
    );
    adder_31bit a2(
        .a(tem_partial_product[1]),
        .b(partial_product[3]),
        .sum(tem_partial_product[2]),
        .cout()
    );
    adder_31bit a3(
        .a(tem_partial_product[2]),
        .b(partial_product[4]),
        .sum(tem_partial_product[3]),
        .cout()
    );
    adder_31bit a4(
        .a(tem_partial_product[3]),
        .b(partial_product[5]),
        .sum(tem_partial_product[4]),
        .cout()
    );
    adder_31bit a5(
        .a(tem_partial_product[4]),
        .b(partial_product[6]),
        .sum(tem_partial_product[5]),
        .cout()
    );
    adder_31bit a6(
        .a(tem_partial_product[5]),
        .b(partial_product[7]),
        .sum(tem_partial_product[6]),
        .cout()
    );
    adder_31bit a7(
        .a(tem_partial_product[6]),
        .b(partial_product[8]),
        .sum(tem_partial_product[7]),
        .cout()
    );
    adder_31bit a8(
        .a(tem_partial_product[7]),
        .b(partial_product[9]),
        .sum(tem_partial_product[8]),
        .cout()
    );
    adder_31bit a9(
        .a(tem_partial_product[8]),
        .b(partial_product[10]),
        .sum(tem_partial_product[9]),
        .cout()
    );
    adder_31bit a10(
        .a(tem_partial_product[9]),
        .b(partial_product[11]),
        .sum(tem_partial_product[10]),
        .cout()
    );
    adder_31bit a11(
        .a(tem_partial_product[10]),
        .b(partial_product[12]),
        .sum(tem_partial_product[11]),
        .cout()
    );
    adder_31bit a12(
        .a(tem_partial_product[11]),
        .b(partial_product[13]),
        .sum(tem_partial_product[12]),
        .cout()
    );
    adder_31bit a13(
        .a(tem_partial_product[12]),
        .b(partial_product[14]),
        .sum(tem_partial_product[13]),
        .cout()
    );
    adder_31bit a14(
        .a(tem_partial_product[13]),
        .b(partial_product[15]),
        .sum(tem_partial_product[14]),
        .cout()
    );
    
    assign product=tem_partial_product[14];
    assign overflow=1'b0;
    assign valid=1'b1;
    

endmodule
//31bit全加器
module adder_31bit(
    input [30:0] a,
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
            for(i=1;i<30;i=i+1)begin:fadd_mul
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

module mini_ALU_16bit_DIV(
    input clk,
    input rst,
    input start,
    input [15:0] X,
    input [15:0] Y,
    output [15:0] quot,
    output [15:0] rem,
    output overflow,
    output reg valid
);
    reg [32:0] Z,next_Z,Z_temp,Z_temp1;
    reg next_state, pres_state;
    reg [3:0] count,next_count;
    reg  next_valid;

    parameter IDLE = 1'b0;
    parameter START = 1'b1;

    assign rem = Z[31:16];
    assign quot = Z[15:0];

    always @ (posedge clk or negedge rst) begin
            if(!rst) begin
                Z          <= 32'd0;
                valid      <= 1'b0;
                pres_state <= 1'b0;
                count      <= 4'd0;
            end
            else begin
                Z          <= next_Z;
                valid      <= next_valid;
                pres_state <= next_state;
                count      <= next_count;
            end
        end

    always @ (*) begin 
            case(pres_state)
                IDLE:
                    begin
                        next_count = 4'b0;
                        next_valid = 1'b0;
                        if(start) begin
                            next_state = START;
                            next_Z     = {16'd0,X};
                        end
                        else begin
                            next_state = pres_state;
                            next_Z     = 32'd0;
                        end
                    end

                START:
                    begin
                        next_count = count + 1'b1;
                        Z_temp     = Z << 1;
                        Z_temp1    = {Z_temp[31:16]-Y,Z_temp[15:0]};
                        next_Z     = Z_temp1[31] ? {Z_temp[31:16],Z_temp[15:1],1'b0} : 
                                        {Z_temp1[31:16],Z_temp[15:1],1'b1};
                        next_valid = (&count) ? 1'b1 : 1'b0; 
                        next_state = (&count) ? IDLE : pres_state;	
                    end
            endcase
    end
    assign overflow = (Y==16'd0)?1'b1:1'b0;

endmodule