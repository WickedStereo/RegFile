`timescale 1ns / 1ps

module RegFile_64_I_mon(
    input clk,
    input rst_n,
    input [4:0] raddr_i_1,
    input [4:0] raddr_i_2,
    input [4:0] waddr_i_1,
    input [63:0] wdata,
    input regwrite,
    input is_16_i,
    input cold_en_i,
    input [63:0] rdata_i_1,
    input [63:0] rdata_i_2,
    input cold_en_err
);
    
    
    initial begin
        $display("All inputs are initialized & reset is asserted");
		#10;
		$display("\nReset is de-asserted");
		#10;
		$display("\nTEST CASE 1: Basic Hot Register Write and Read");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, Cold enable:0x%d | Port1=0x%h & Port2=0x%h (Both Ports Expected: 0x123456789ABCDEF0), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nTEST CASE 2: Basic Cold Register Write and Read");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Both Ports Expected: 0xABCDEF0123456789), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nCold Enable disabled");
		#10;
		$display("\nTEST CASE 3: Cold Register Access with and without Authorization");
		$display("\nAttempting Unauthorized write to cold register x4");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Port1 Expected: 0xDEADBEEFDEADBEEF), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nAttempting Authorized write to cold register x4");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Port1 Expected: 0xCAFEBABECAFEBABE), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nTEST CASE 4: 16-bit Instruction Mode Behavior");
		$display("\nRead and Write with Zero Register");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, 16b enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,is_16_i,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, 16b enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Both Ports Expected: 0xABABABABABABABAB), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,is_16_i,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nHot Registers accessing cold registers");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, 16b enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,is_16_i,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, 16b enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Both Ports Expected: 0xCDCDCDCDCDCDCDCD), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,is_16_i,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nHot Registers accessing hot registers");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, 16b enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,is_16_i,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, 16b enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Both Ports Expected: 0xEFEFEFEFEFEFEFEF), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,is_16_i,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nCold Registers accessing cold registers");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, 16b enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,is_16_i,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, 16b enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Both Ports Expected: 0xADADADADADADADAD), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,is_16_i,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nTEST CASE 5: Simultaneous Read/Write and Read Conflict Testing");
		$display("\nSetting Up Initial Values");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, 16b enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,is_16_i,cold_en_i);
		#10;
	    $display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, 16b enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,is_16_i,cold_en_i);
		#10;
		$display("\nRead from both ports while writing");
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, 16b enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Port1 Expected:0xA1A2A3A4B1B2B3B4, Port2 Expected:0xC1C2C3C4D1D2D3D4), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,is_16_i,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, 16b enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,is_16_i,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, 16b enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Port1 Expected:0xE1E2E3E4F1F2F3F4, Port2 Expected:0xC1C2C3C4D1D2D3D4), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,is_16_i,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nTEST CASE 6: Reset Functionality");
		$display("\nReset Asserted");
		#10;
		$display("\nReset De-Asserted");
		#10;
		$display("\nCheck if registers were cleared (both hot & cold) & check if cold_en_err was resetted");
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, 16b enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Both Ports Expected:0x0000000000000000), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,is_16_i,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nTEST CASE 7: Edge Cases and Special Conditions");
		$display("\nTest X0 zero register behavior in normal mode");
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, 16b enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Both Ports Expected:0x0000000000000000), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,is_16_i,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nTest to write into X0 zero register in normal mode");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, 16b enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,is_16_i,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, 16b enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Both Ports Expected:0x0000000000000000), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,is_16_i,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		$display("\nTest unauthorized cold access in 16-bit mode");
		$display("\nWriting data to Register 0x%d: Write data:0x%h, Write enable:0x%d, 16b enable:0x%d, Cold enable:0x%d ",waddr_i_1,wdata,regwrite,is_16_i,cold_en_i);
		#10;
		$display("\nReading data from Register 0x%d & Register 0x%d, Write enable:0x%d, 16b enable:0x%d, Cold Enable:0x%d | Port1=0x%h & Port2=0x%h (Both Ports Expected:0x0000000000000000), Cold enable error:0x%d",raddr_i_1,raddr_i_2,regwrite,is_16_i,cold_en_i,rdata_i_1,rdata_i_2,cold_en_err);
		#10;
		#10;
		$display("\nAll test cases completed!");
	end
    
endmodule

