`timescale 1ns / 1ps

module RegFile_64_I_stim(
	output reg clk,
    output reg rst_n,
    output reg [4:0] raddr_i_1,
    output reg [4:0] raddr_i_2,
    output reg [4:0] waddr_i_1,
    output reg [63:0] wdata,
    output reg regwrite,
    output reg is_16_i,
    output reg cold_en_i
);
    

    always #5 clk = ~clk;
    
    initial begin
        // Initialize Inputs
        clk = 1;
        rst_n = 0;
        raddr_i_1 = 0;
        raddr_i_2 = 0;
        waddr_i_1 = 0;
        wdata = 0;
        regwrite = 0;
        is_16_i = 0;
        cold_en_i = 0;
        
        // deassert reset
        #10 rst_n = 1;
        #10;
        
        ////////////////////////////////////////////////////////////////////
        // TEST CASE 1: Basic Hot Register Write and Read
        ////////////////////////////////////////////////////////////////////
        
        // Write to hot register x1 (address 1)
        waddr_i_1 = 5'd1;
        wdata = 64'h123456789ABCDEF0;
        regwrite = 1;
        #10;
        regwrite = 0;
        
        // Read from hot x1 using both read ports
        raddr_i_1 = 5'd1;
        raddr_i_2 = 5'd1;
        #10;

                 
        ////////////////////////////////////////////////////////////////////
        // TEST CASE 2: Basic Cold Register Write and Read
        ////////////////////////////////////////////////////////////////////
        
        // Write to cold register x3 (address 3)
        cold_en_i = 1;
        waddr_i_1 = 5'd3;
        wdata = 64'hABCDEF0123456789;
        regwrite = 1;
        #10;
        regwrite = 0;
        
        // Read from x1 using both read ports
        cold_en_i = 1;
        raddr_i_1 = 5'd3;
        raddr_i_2 = 5'd3;
        #10;
        
        cold_en_i = 0;        
        #10;
        
        ////////////////////////////////////////////////////////////////////
        // TEST CASE 3: Cold Register Access with and without Authorization
        ////////////////////////////////////////////////////////////////////
        
        // Attempt unauthorized write to cold register x4 (should fail)
        waddr_i_1 = 5'd4;
        wdata = 64'hDEADBEEFDEADBEEF;
        regwrite = 1;
        #10;
        regwrite = 0;
        
        // Attempt unauthorized read from cold register x4 (should fail)
        raddr_i_1 = 5'd4;            
        raddr_i_2 = 5'd0; // Read x0 for comparison
        #10;
        
        // Authorized write to cold register x4
        cold_en_i = 1;
        waddr_i_1 = 5'd4;
        wdata = 64'hCAFEBABECAFEBABE;
        regwrite = 1;
        #10;
        regwrite = 0;
        
        // Authorized read from cold register x4
        cold_en_i = 1;
        raddr_i_1 = 5'd4;
        #10;
        
        ////////////////////////////////////////////////////////////////////
        // TEST CASE 4: 16-bit Instruction Mode Behavior
        ////////////////////////////////////////////////////////////////////
        
        //Zero Register 
        //write
        waddr_i_1 = 5'd0;
        is_16_i = 1;
        wdata = 64'hABABABABABABABAB;     //stores in X8
        regwrite = 1;
        #10;
        regwrite = 0;
        
        //read
        is_16_i = 1;
        raddr_i_1 = 5'd0;
        raddr_i_2 = 5'd8;
        #10;
                 
        //Hot registers (accessing cold registers)
        //write
        waddr_i_1 = 5'd5;
        is_16_i = 1;
        cold_en_i = 1;
        wdata = 64'hCDCDCDCDCDCDCDCD;     //stores in X13 (cold register)
        regwrite = 1;
        #10;
        regwrite = 0;
        
        //read
        is_16_i = 1;
        cold_en_i = 1;
        raddr_i_1 = 5'd5;
        raddr_i_2 = 5'd13;
        #10;

        
        //Hot registers (accessing hot registers)
        
        cold_en_i = 0;  //simply setting it zero (since not accessing cold registers)
        
        //write
        waddr_i_1 = 5'd2;
        is_16_i = 1;
        wdata = 64'hEFEFEFEFEFEFEFEF;     //stores in X10 (hot register)
        regwrite = 1;
        #10;
        regwrite = 0;
        
        //read
        is_16_i = 1;
        raddr_i_1 = 5'd2;
        raddr_i_2 = 5'd10;
        #10;

                 
        //Cold registers (accessing cold registers)
        waddr_i_1 = 5'd4;
        is_16_i = 1;
        cold_en_i = 1;
        wdata = 64'hADADADADADADADAD;    //stores in X12 (cold register)  
        regwrite = 1;
        #10;
        regwrite = 0;
        
        //read
        is_16_i = 1;
        cold_en_i = 1;
        raddr_i_1 = 5'd4;
        raddr_i_2 = 5'd12;
        #10;

        
        //Cold registers (accessing hot registers)
        //Not Applicable

        // Disable 16-bit mode
        is_16_i = 0;
        
        ////////////////////////////////////////////////////////////////////
        // TEST CASE 5: Simultaneous Read/Write and Read Conflict Testing
        ////////////////////////////////////////////////////////////////////
        
        // Setup initial values
        waddr_i_1 = 5'd5; // x5 (hot)
        wdata = 64'hA1A2A3A4B1B2B3B4;
        regwrite = 1;
        #10;
        regwrite = 0;
        
        waddr_i_1 = 5'd17; // x17 (cold)
        wdata = 64'hC1C2C3C4D1D2D3D4;
        cold_en_i = 1;
        regwrite = 1;
        #10;
        regwrite = 0;
        
        // Read from both ports while writing
        raddr_i_1 = 5'd5;  // Read x5
        cold_en_i = 1;
        raddr_i_2 = 5'd17; // Read x17
        waddr_i_1 = 5'd6;  // Write to x6
        wdata = 64'hE1E2E3E4F1F2F3F4;
        regwrite = 1;
        #10;
 
        regwrite = 0;
        
        // Verify write was successful
        raddr_i_1 = 5'd6;
        #10;

        
        ////////////////////////////////////////////////////////////////////
        // TEST CASE 6: Reset Functionality
        ////////////////////////////////////////////////////////////////////
        
        // Apply reset
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;
        
        // Check if registers were cleared
        raddr_i_1 = 5'd1;  // x1 (hot)
        cold_en_i = 1;
        raddr_i_2 = 5'd3;  // x3 (cold)
        #10;

        
        // Check cold_en_err was reset

        
        ////////////////////////////////////////////////////////////////////
        // TEST CASE 7: Edge Cases and Special Conditions
        ////////////////////////////////////////////////////////////////////

        
        // Test x0 behavior in normal mode
        raddr_i_1 = 5'd0;
        #10;

        
        // Test write to x0 in normal mode (should be ignored)
        waddr_i_1 = 5'd0;
        wdata = 64'hBAD0BAD0BAD0BAD0;
        regwrite = 1;
        #10;
        regwrite = 0;
        raddr_i_1 = 5'd0;
        #10;

        
        // Test unauthorized cold access in 16-bit mode
        //write
        waddr_i_1 = 5'd1;
        wdata = 64'hBEBEBEBEBEBEBEBE;
        is_16_i = 1;
        cold_en_i = 0;    //deliberately asserted zero for unauthorized access
        #10;

        //read
        raddr_i_1 = 5'd1; 
        raddr_i_2 =5'd9;
        is_16_i = 1;
        cold_en_i = 0;  //deliberately asserted zero for unauthorized access
        #10;
        
        #10;
        $finish;
    end
    
endmodule
