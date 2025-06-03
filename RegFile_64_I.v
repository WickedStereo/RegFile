`timescale 1ns / 1ps

module RegFile_64_I (  
    input clk,
    input rst_n, //active low reset
    input wire [4:0] raddr_i_1, //1st operand addr to the regfile
    input wire [4:0] raddr_i_2, //2nd operand addr to the regfile
    input wire [4:0] waddr_i_1, //writeback addr into the regfile
    input wire [63:0] wdata,    //64 bit data that needs to be written back
    input wire regwrite,    //control sig to enable writes into the regfile
    input wire is_16_i,   //control sig to indicate the operand addr is from 16bit ins
    input wire cold_en_i,   //control sig to enable read and write into the cold reg
    output reg [63:0] rdata_i_1,   //64bit value of the 1st operand
    output reg [63:0] rdata_i_2,    //64bit value of the 2nd operand
    output reg cold_en_err //error sig to indicate the cold_en_i status for reads
);

//--------------------------------
// Hot registers
//--------------------------------

reg [63:0] x1, x2, x5, x6, x7, x8, x10, x11;

//--------------------------------
// Hardwired register x0
//--------------------------------

wire [63:0] x0 = 64'b0;

//---------------------------------
// Cold registers
//---------------------------------

reg [63:0] x3, x4, x9, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22,
           x23, x24, x25, x26, x27, x28, x29, x30, x31;
           
//For 16bit instruction it can write or read into specific registers. 
//Those can hot or cold registers

//We can read or write from/to cold registers using cold_en_i


//----------------------------------
// Reset and writes into hot and cold registers
//----------------------------------

always @(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        //hot reg reset
        x1 <= 64'b0;
        x2 <= 64'b0;
        x5 <= 64'b0;
        x6 <= 64'b0;
        x7 <= 64'b0;
        x8 <= 64'b0;
        x10 <= 64'b0;
        x11 <= 64'b0;
        //cold reg reset
        x3 <= 64'b0;
        x4 <= 64'b0;
        x9 <= 64'b0;
        x12 <= 64'b0;
        x13 <= 64'b0;
        x14 <= 64'b0;
        x15 <= 64'b0;
        x16 <= 64'b0;
        x17 <= 64'b0;
        x18 <= 64'b0;
        x19 <= 64'b0;
        x20 <= 64'b0;
        x21 <= 64'b0;
        x22 <= 64'b0;
        x23 <= 64'b0;
        x24 <= 64'b0;
        x25 <= 64'b0;
        x26 <= 64'b0;
        x27 <= 64'b0;
        x28 <= 64'b0;
        x29 <= 64'b0;
        x30 <= 64'b0;
        x31 <= 64'b0;
        //output init.
        cold_en_err <= 0;
    end
    //only write when regwrite is asserted
    else if(regwrite) begin

        case (waddr_i_1)

        //Hot register writes and the writes if operand from 16bit ins
//            5'd1:
//            if (is_16_i) begin
//                if (cold_en_i) begin
//                    x9 <= wdata;
//                end
//            end 
//            else begin 
//                x1 <= wdata;
//            end
            
            5'd1:
            if (is_16_i) begin
                if (cold_en_i) begin
                    x9 <= wdata;
                    cold_en_err <= 0;
                end
                else begin
                    cold_en_err <= 1;
                end
            end 
            else begin 
                x1 <= wdata;
                cold_en_err <= 0;
            end

            5'd2:
            if (is_16_i) begin
                x10 <= wdata;
                cold_en_err <= 0;
            end 
            else begin
                x2 <= wdata;
                cold_en_err <= 0;
            end

//            5'd5:
//            if (is_16_i) begin
//                if (cold_en_i) begin
//                    x13 <= wdata;
//                end
//            end 
//            else begin
//              x5 <= wdata;
//            end
            
            5'd5:
            if (is_16_i) begin
                if (cold_en_i) begin
                    x13 <= wdata;
                    cold_en_err <= 0;
                end
                else begin
                    cold_en_err <= 1;
                end
            end 
            else begin
              x5 <= wdata;
              cold_en_err <= 0;
            end

//            5'd6:
//            if (is_16_i) begin
//                if (cold_en_i) begin 
//                    x14 <= wdata;
//                end
//            end
//            else begin
//                x6 <= wdata;
//            end
            
            5'd6:
            if (is_16_i) begin
                if (cold_en_i) begin 
                    x14 <= wdata;
                    cold_en_err <= 0;
                end
                else begin
                    cold_en_err <= 1;
                end
            end
            else begin
                x6 <= wdata;
                cold_en_err <= 0;
            end

//            5'd7: 
//            if (is_16_i) begin 
//                if (cold_en_i) begin
//                    x15 <= wdata;
//                end
//            end
//            else begin
//                x7 <= wdata;
//            end
            
            5'd7: 
            if (is_16_i) begin 
                if (cold_en_i) begin
                    x15 <= wdata;
                    cold_en_err <= 0;
                end
                else begin
                    cold_en_err <= 1;
                end
            end
            else begin
                x7 <= wdata;
                cold_en_err <= 0;
            end

            5'd8: begin
                    x8 <= wdata; 
                    cold_en_err <= 0;
                  end

            5'd10: begin
                    x10 <= wdata; 
                    cold_en_err <= 0;
                  end

            5'd11: begin
                    x11 <= wdata; 
                    cold_en_err <= 0;
                  end

        //ignore writes to x0 unless its a 16bit ins
            5'd0: 
            if (is_16_i) begin
                x8 <= wdata;
                cold_en_err <= 0;
            end
        //Cold register writes
            5'd3: 
            if (cold_en_i) begin
                if (is_16_i) begin
                    x11 <= wdata;
                    cold_en_err <= 0;
                end
                else begin
                    x3 <= wdata;
                    cold_en_err <= 0;
                end    
            end 
            else begin
                cold_en_err <= 1;
            end

            5'd4:
            if (cold_en_i) begin
                if (is_16_i) begin
                    x12 <= wdata;
                    cold_en_err <= 0;
                end
                else begin
                x4 <= wdata;
                cold_en_err <= 0;
                end
            end
            else begin
                cold_en_err <= 1;
            end

            5'd9:
            if (cold_en_i) begin
                x9 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd12:
            if (cold_en_i) begin
                x12 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd13:
            if (cold_en_i) begin
                x13 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd14:
            if (cold_en_i) begin
                x14 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd15:
            if (cold_en_i) begin
                x15 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd16:
            if (cold_en_i) begin
                x16 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd17:
            if (cold_en_i) begin
                x17 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd18:
            if (cold_en_i) begin
                x18 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd19:
            if (cold_en_i) begin
                x19 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd20:
            if (cold_en_i) begin
                x20 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd21:
            if (cold_en_i) begin
                x21 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd22:
            if (cold_en_i) begin
                x22 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd23:
            if (cold_en_i) begin
                x23 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd24:
            if (cold_en_i) begin
                x24 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd25:
            if (cold_en_i) begin
                x25 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd26:
            if (cold_en_i) begin
                x26 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd27:
            if (cold_en_i) begin
                x27 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd28:
            if (cold_en_i) begin
                x28 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd29:
            if (cold_en_i) begin
                x29 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd30:
            if (cold_en_i) begin
                x30 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
            
            5'd31:
            if (cold_en_i) begin
                x31 <= wdata;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end

        endcase
    end

end

//-----------------------------------------------------
// Read Logic for Port 1
//-----------------------------------------------------

// Reads are asynchronous
// Need to check for 16bit reg encoding !

always @(*) begin
    case (raddr_i_1)
        
        5'd0:
        if (is_16_i) begin
            rdata_i_1 = x8;  
            cold_en_err <= 0;
        end 
        else begin
            rdata_i_1 = 64'b0;
            cold_en_err <= 0;
        end

        5'd1:
        if (is_16_i) begin
            if (cold_en_i) begin 
                rdata_i_1 = x9;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
        end
        else begin
            rdata_i_1 = x1;
            cold_en_err <= 0;
        end

        5'd2:
        if (is_16_i) begin
            rdata_i_1 = x10;
            cold_en_err <= 0;
        end
        else begin
            rdata_i_1 = x2;
            cold_en_err <= 0;
        end

        5'd3:
        if (is_16_i) begin
            rdata_i_1 = x11;
            cold_en_err <= 0;
        end
        else if (cold_en_i) begin
            rdata_i_1 = x3;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

//        5'd4:
//        if (is_16_i) begin
//            rdata_i_1 = x12;
//        end
//        else if (cold_en_i) begin
//            rdata_i_1 = x4;
//        end
//        else begin
//            cold_en_err <= 1;
//        end
        
        5'd4:
        if (is_16_i) begin
            if (cold_en_i) begin
                rdata_i_1 = x12;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
        end
        else if (cold_en_i) begin
            rdata_i_1 = x4;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd5:
        if (is_16_i) begin
            if(cold_en_i) begin
                rdata_i_1 = x13;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
        end
        else begin
            rdata_i_1 = x5;
            cold_en_err <= 0;
        end

        5'd6:
        if (is_16_i) begin
            if(cold_en_i) begin
                rdata_i_1 = x14;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
        end
        else begin
            rdata_i_1 = x6;
            cold_en_err <= 0;
        end

        5'd7:
        if (is_16_i) begin
            if(cold_en_i) begin
                rdata_i_1 = x15;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
        end
        else begin
            rdata_i_1 = x7;
            cold_en_err <= 0;
        end

        5'd8: begin
                rdata_i_1 = x8;
                cold_en_err <= 0;
              end

        5'd9:
        if (cold_en_i) begin
            rdata_i_1 = x9;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd10: begin
                 rdata_i_1 = x10;
                 cold_en_err <= 0;
               end

        5'd11: begin
                 rdata_i_1 = x11;
                 cold_en_err <= 0;
               end

        5'd12:
        if (cold_en_i) begin
            rdata_i_1 = x12;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd13:
        if (cold_en_i) begin
            rdata_i_1 = x13;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd14:
        if (cold_en_i) begin
            rdata_i_1 = x14;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd15:
        if (cold_en_i) begin
            rdata_i_1 = x15;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd16:
        if (cold_en_i) begin
            rdata_i_1 = x16;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd17:
        if (cold_en_i) begin
            rdata_i_1 = x17;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd18:
        if (cold_en_i) begin
            rdata_i_1 = x18;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd19:
        if (cold_en_i) begin
            rdata_i_1 = x19;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd20:
        if (cold_en_i) begin
            rdata_i_1 = x20;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd21:
        if (cold_en_i) begin
            rdata_i_1 = x21;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd22:
        if (cold_en_i) begin
            rdata_i_1 = x22;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd23:
        if (cold_en_i) begin
            rdata_i_1 = x23;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd24:
        if (cold_en_i) begin
            rdata_i_1 = x24;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd25:
        if (cold_en_i) begin
            rdata_i_1 = x25;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd26:
        if (cold_en_i) begin
            rdata_i_1 = x26;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd27:
        if (cold_en_i) begin
            rdata_i_1 = x27;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd28:
        if (cold_en_i) begin
            rdata_i_1 = x28;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd29:
        if (cold_en_i) begin
            rdata_i_1 = x29;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd30:
        if (cold_en_i) begin
            rdata_i_1 = x30;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd31:
        if (cold_en_i) begin
            rdata_i_1 = x31;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
 
    endcase
end

//---------------------------------------------------
// Read Logic for port 2
//---------------------------------------------------

always @(*) begin
    case (raddr_i_2)
        
        5'd0:
        if (is_16_i) begin
            rdata_i_2 = x8;  
            cold_en_err <= 0;
        end 
        else begin
            rdata_i_2 = 64'b0;
            cold_en_err <= 0;
        end

        5'd1:
        if (is_16_i) begin
            if (cold_en_i) begin 
                rdata_i_2 = x9;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
        end
        else begin
            rdata_i_2 = x1;
            cold_en_err <= 0;
        end

        5'd2:
        if (is_16_i) begin
            rdata_i_2 = x10;
            cold_en_err <= 0;
        end
        else begin
            rdata_i_2 = x2;
            cold_en_err <= 0;
        end

        5'd3:
        if (is_16_i) begin
            rdata_i_2 = x11;
            cold_en_err <= 0;
        end
        else if (cold_en_i) begin
            rdata_i_2 = x3;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

//        5'd4:
//        if (is_16_i) begin
//            rdata_i_1 = x12;
//        end
//        else if (cold_en_i) begin
//            rdata_i_1 = x4;
//        end
//        else begin
//            cold_en_err <= 1;
//        end
        
        5'd4:
        if (is_16_i) begin
            if (cold_en_i) begin
                rdata_i_2 = x12;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
        end
        else if (cold_en_i) begin
            rdata_i_2 = x4;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd5:
        if (is_16_i) begin
            if(cold_en_i) begin
                rdata_i_2 = x13;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
        end
        else begin
            rdata_i_2 = x5;
            cold_en_err <= 0;
        end

        5'd6:
        if (is_16_i) begin
            if(cold_en_i) begin
                rdata_i_2 = x14;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
        end
        else begin
            rdata_i_2 = x6;
            cold_en_err <= 0;
        end

        5'd7:
        if (is_16_i) begin
            if(cold_en_i) begin
                rdata_i_2 = x15;
                cold_en_err <= 0;
            end
            else begin
                cold_en_err <= 1;
            end
        end
        else begin
            rdata_i_2 = x7;
            cold_en_err <= 0;
        end

        5'd8: begin
                rdata_i_2 = x8;
                cold_en_err <= 0;
              end

        5'd9:
        if (cold_en_i) begin
            rdata_i_2 = x9;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd10: begin
                 rdata_i_2 = x10;
                 cold_en_err <= 0;
               end

        5'd11: begin
                 rdata_i_2 = x11;
                 cold_en_err <= 0;
               end

        5'd12:
        if (cold_en_i) begin
            rdata_i_2 = x12;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd13:
        if (cold_en_i) begin
            rdata_i_2 = x13;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd14:
        if (cold_en_i) begin
            rdata_i_2 = x14;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd15:
        if (cold_en_i) begin
            rdata_i_2 = x15;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd16:
        if (cold_en_i) begin
            rdata_i_2 = x16;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd17:
        if (cold_en_i) begin
            rdata_i_2 = x17;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd18:
        if (cold_en_i) begin
            rdata_i_2 = x18;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd19:
        if (cold_en_i) begin
            rdata_i_2 = x19;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd20:
        if (cold_en_i) begin
            rdata_i_2 = x20;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd21:
        if (cold_en_i) begin
            rdata_i_2 = x21;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd22:
        if (cold_en_i) begin
            rdata_i_2 = x22;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd23:
        if (cold_en_i) begin
            rdata_i_2 = x23;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd24:
        if (cold_en_i) begin
            rdata_i_2 = x24;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd25:
        if (cold_en_i) begin
            rdata_i_2 = x25;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd26:
        if (cold_en_i) begin
            rdata_i_2 = x26;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
        
        5'd27:
        if (cold_en_i) begin
            rdata_i_2 = x27;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd28:
        if (cold_en_i) begin
            rdata_i_2 = x28;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd29:
        if (cold_en_i) begin
            rdata_i_2 = x29;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd30:
        if (cold_en_i) begin
            rdata_i_2 = x30;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end

        5'd31:
        if (cold_en_i) begin
            rdata_i_2 = x31;
            cold_en_err <= 0;
        end
        else begin
            cold_en_err <= 1;
        end
 
    endcase
end
    
endmodule



