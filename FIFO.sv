// Ashika Palacharla
// Nithya Subramanian
// 1/28/2025
// EE371
// Lab 2 Task 3: FIFO Design

//The FIFO module takes in 2 parameters depth and width as well as inputs
//clk, reset, read and write which are all 1-bit inputs. It also takes in
//a data of length width - 1 as the inputBus. The module outputs empty and
//full signals of 1-bit that tell us when the memory is empty or full.
//it also inputs the outputBus of a bit size of width-1. This module 
//instatntiates our dual port ram and control module.
module FIFO #(
				  parameter depth = 4,
				  parameter width = 8
				  )(
					 input logic clk, reset,
					 input logic read, write,
					 input logic [width-1:0] inputBus,
					output logic empty, full,
					output logic [width-1:0] outputBus
				   );
					
	/* 	Define_Variables_Here		*/
	logic wr_en;
	logic [3:0] readAddr, writeAddr;
	
	
	/*			Instantiate_Your_Dual-Port_RAM_Here			*/
	ram16x8 ram(.clock(clk), .data(inputBus), .rdaddress(readAddr),
						.wraddress(writeAddr), .wren(wr_en), .q(outputBus));
	
	
	/*			FIFO-Control_Module			*/				
	FIFO_Control #(depth) FC (.clk, .reset, .read, .write, .wr_en, .empty,
									.full, .readAddr, .writeAddr);
	
endmodule 

//The testbench for the FIFO_testbench that simulates all scenarios
module FIFO_testbench();
	
	parameter depth = 4, width = 8;
	
	logic clk, reset;
	logic read, write;
	logic [width-1:0] inputBus;
	logic resetState;
	logic empty, full;
	logic [width-1:0] outputBus;
	
	FIFO #(depth, width) dut (.*);
	
	parameter CLK_Period = 100;
	
	initial begin
		clk <= 1'b0;
		forever #(CLK_Period/2) clk <= ~clk;
	end
	
	initial begin 
		reset <= 1; 																	@(posedge clk);
																							@(posedge clk);
		reset<= 0;																		@(posedge clk);
																							@(posedge clk);
																							@(posedge clk);
		//should light up LEDR empty
		read <= 1;																		@(posedge clk);
																							@(posedge clk);	
		read <= 0; write <= 1; inputBus <= 8'h00;								@(posedge clk);
																							@(posedge clk);
																							@(posedge clk);
		write <= 0;																		@(posedge clk);
																							@(posedge clk);
		//fill the memory fully 
		write <= 1; inputBus <= 8'h01;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h02;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h03;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h04;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h05;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h06;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h07;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h08;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h09;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h0a;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h0b;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h0c;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h0d;									@(posedge clk);
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h0e;									@(posedge clk);		
																							@(posedge clk);
		write <= 0; 															@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h0f;									@(posedge clk); //should light up LEDR full
																							@(posedge clk);		
		write <= 0; 															@(posedge clk);
																							@(posedge clk);


		//check to see condition when already full memory is written to
		write <= 1; inputBus <= 8'h1c;									@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h1d;									@(posedge clk);
																							@(posedge clk);
		write <= 1; inputBus <= 8'h1e;									@(posedge clk);		
																							@(posedge clk);
		write <= 1; inputBus <= 8'h1f;									@(posedge clk);			
																							@(posedge clk);
		write <= 0;																@(posedge clk);
		
		//Check to see read operations after full
		read <= 1; repeat(16);														@(posedge clk);
																							@(posedge clk);
		
		//read and write functions on at the same time
		read <= 1; 	write <= 1; inputBus <= 8'h00;							@(posedge clk);
																							@(posedge clk);
		inputBus <= 8'h01;															@(posedge clk);
																							@(posedge clk);
		inputBus <= 8'h02;															@(posedge clk);
																							@(posedge clk);
		inputBus <= 8'h03;															@(posedge clk);
																							@(posedge clk);
		inputBus <= 8'h04;															@(posedge clk);
																							@(posedge clk);
		inputBus <= 8'h05;															@(posedge clk);
																							@(posedge clk);
	
		$stop;
	end
endmodule 
