// Ashika Palacharla
// Nithya Subramanian
// 1/28/2025
// EE371
// Lab 2 Task 3: FIFO Design

// Top-level module that defines the I/Os for the DE-1 SoC board
//Takes in the inputs CLOCK_50, SW and KEY. CLOCK_50 is the synchronous 
//clock while SW and KEY are the input data and button press scenarios 
//that can occur(reset, write, read) respectivley. The output signals 
//are LEDR and HEX0-HEX5 where the LEDR/HEX outputs are active low.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR);

	// Define ports
	input  logic CLOCK_50; //50MHz clock on board
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; //output to 7-segment HEX display
	input  logic [3:0] KEY;
	input  logic [9:0] SW;
	output logic [9:0] LEDR;
	
	logic [4:0] r_addr, wr_addr;
	logic [3:0] d_in, d_out;
	logic wr_en;
	logic reset, read, write;
	
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	
	logic [7:0] inputBus, outputBus;
	assign inputBus = SW[7:0];
	
	
	//All three buttonPress calls(reset, read, write) take the button presses as inputs and then
	//outputs the reset, read or write signal(respectivley)
	buttonPress bp_reset(.clk(CLOCK_50), .in(~KEY[0]), .out(reset));
	buttonPress bp_read(.clk(CLOCK_50), .in(~KEY[3]), .out(read));
	buttonPress bp_write(.clk(CLOCK_50), .in(~KEY[2]), .out(write));
	
	//seg7_hex module call takes the outputs given by the FIFO method and 
	//the inputs/outputs given by the bus to correctly display the data 
	// onto the HEX displays.
	seg7_hex hex5 (.val(inputBus[7:4]), .display(HEX5));
	seg7_hex hex4 (.val(inputBus[3:0]), .display(HEX4));
	seg7_hex hex1 (.val(outputBus[7:4]), .display(HEX1));
	seg7_hex hex0 (.val(outputBus[3:0]), .display(HEX0));
	
	//FIFO method call takes the input from the buttonPress moudles output and 
	//the data given by the input bus and does the "function" it is asked to do
	//if the data is empty it outputs LEDR 8 or full it outputs high for LEDR 9
	//and outputs the data that into the outputBus. 
	FIFO fifo_inst(.clk(CLOCK_50), .reset(reset), .read(read), .write(write),
							.inputBus(inputBus), .empty(LEDR[8]), .full(LEDR[9]),
							.outputBus(outputBus));
	
endmodule //DE1_SoC

//The testbench for the DE1_SoC_testbench simulates all scenarios
`timescale 1 ps / 1 ps

module DE1_SoC_testbench();
	logic CLOCK_50; //50MHz clock on board
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; //output to 7-segment HEX display
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [9:0] LEDR;
	
	logic [4:0] r_addr, wr_addr;
	logic [3:0] d_in, d_out;
	logic wr_en;
	logic reset, read, write;
	
	logic [7:0] inputBus, outputBus;
	logic clk;
	
	DE1_SoC dut (.CLOCK_50(clk), .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .LEDR);

	assign SW[7:0] = inputBus;
	assign KEY[0] = ~reset;
	assign KEY[3] = ~read;
	assign KEY[2] = ~write;
		
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	
	parameter CLOCK_PERIOD = 100;
	initial begin 
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
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


		//check to see condition when already full memory is added to
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
		repeat(16) begin
			read <= 1;																		@(posedge clk);
			read <= 0;																		@(posedge clk);
		end
		
		
		
		//read and write functions on at the same time
		read <= 1; 	write <= 1; inputBus <= 8'h00;							@(posedge clk);
																							@(posedge clk);
		read <= 0; write <= 0; 														@(posedge clk);
																							@(posedge clk);
		read <= 1; 	write <= 1; inputBus <= 8'h01;							@(posedge clk);
																							@(posedge clk);
		read <= 0; write <= 0; 														@(posedge clk);
																							@(posedge clk);
		read <= 1; 	write <= 1; inputBus <= 8'h02;							@(posedge clk);
																							@(posedge clk);
		read <= 0; write <= 0; 														@(posedge clk);
																							@(posedge clk);
		read <= 1; 	write <= 1; inputBus <= 8'h03;							@(posedge clk);
																							@(posedge clk);
		read <= 0; write <= 0; 														@(posedge clk);
																							@(posedge clk);
		read <= 1; 	write <= 1; inputBus <= 8'h04;							@(posedge clk);
																							@(posedge clk);
		//read and write off but input given
		read <= 0; 	write <= 0; inputBus <= 8'h05;							@(posedge clk);
																							@(posedge clk);
	
		$stop;
	end
endmodule
										