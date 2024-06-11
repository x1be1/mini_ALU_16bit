// +FHDR----------------------------------------------------------------------------
//            
//                
// ---------------------------------------------------------------------------------
// Filename        : mini_ALU_16bit_DIV.v
// Author          : xibei
// cinreated On    : 2024-06-06 20:30
// Last Modified   : 2024-06-08 22:50
// ---------------------------------------------------------------------------------
// Descinription   :  恢复余数除法，消耗时钟为计数器数，状态机编码
//                   
//                               
// -FHDR----------------------------------------------------------------------------
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