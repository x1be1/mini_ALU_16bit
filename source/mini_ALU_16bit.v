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
 