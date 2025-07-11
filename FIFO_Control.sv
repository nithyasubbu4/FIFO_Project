// Ashika Palacharla
// Nithya Subramanian
// 1/28/2025
// EE371
// Lab 2 Task 3: FIFO Design

//The FIFO_Control module takes in 2 parameters depth and width as well as inputs
//clk, reset, read and write which are all 1-bit inputs.The module outputs empty and
//full signals of 1-bit that tell us when the memory is empty or full.
//it also outputs the read and write addresses of a bit size of width-1. This module
//deals with scenarios where the read and write operations are true at the same time
//as well as the scenario where the FIFO is empty or full. When the reset signal is
//high the module resets all values to 0.
module FIFO_Control #(
							 parameter depth = 4
							 )(
								input logic clk, reset,
								input logic read, write,
							  output logic wr_en,
							  output logic empty, full,
							  output logic [depth-1:0] readAddr, writeAddr
							  );
	
	/* 	Define_Variables_Here		*/
	// Create integer 'e' for number of elements in FIFO
	integer e;
	//Create integer 'old' to track address for least recent element in FIFO
	integer old;
	
	
	/*		Sequential_Logic_Here		*/
	always_ff @(posedge clk) begin
		//reset the read and write address
		//set empty to 1 and full to 0
		//reset the e and old variables
		if(reset) begin
			e <= 0;
			old <= 0;
			readAddr <= '0;
			writeAddr <= '0;
			empty <= 1'b1;
			full <= 1'b0;			
		end
		
		//if read or write operation is true
		else if(read | write) begin
			//when read and write are both true
			if(read & write) begin
				readAddr <= old; //set read to the least recent element address
				wr_en <= 1'b1; //enable write
				old <= (old+1)%(2**depth); //update old, increment by 1 and wrap around
				writeAddr <= (old+e)%(2**depth); //update write address
							//at address of least recent element + number of elements (next empty space)
			end
			
			//read operation, and FIFO is not empty
			else if(read & ~empty) begin
				if(e == 1) begin //only one element in fifo, so clear after read
					full <= 1'b0;
					empty <= 1'b1; //update to empty
				end
				
				full <= 1'b0;
				wr_en <= 1'b0; //turn off write enable during read
				
				readAddr <= old; //update read address to oldest element
				e <= e-1; //decrement number of elements in FIFO
				old <= (old+1)%(2**depth);//update address of oldest element, wrap around address as needed
			end
			
			//write operation, and FIFO is not full
			else if(write & ~full) begin
				if(e == (2**depth - 1)) begin //fifo is one away from full
					full <= 1'b1; //one element is added, so fifo becomes full
					empty <= 1'b0;
				end
				
				wr_en <= 1'b1; //enable write during write
				empty <= 1'b0; //fifo has elements, so empty false
				
				writeAddr <= (old+e)%(2**depth); //write to address of oldest element+number of elements
					//next open spot in fifo
				e <= e+1; //new element added, increment number of elements in FIFO
			end
			//make write enable 0 otherwise
			else
				wr_en <= 1'b0;
				
		end //end else-if
	end //always_ff

endmodule 

//The testbench for the FIFO_Control_testbench that simulates all scenarios
module FIFO_Control_testbench();
	parameter depth = 4, width = 8;
	
	logic clk, reset;
	logic read, write;
	logic wr_en;
	logic [depth-1:0] readAddr, writeAddr;
	logic empty, full;
	
	FIFO_Control #(depth, width) dut (.*);
	
	parameter CLK_Period = 100;
	
	initial begin
		clk <= 1'b0;
		forever #(CLK_Period/2) clk <= ~clk;
	end
	
	initial begin 
		reset <= 1; 																	@(posedge clk);
																							@(posedge clk);
		reset <= 0;																		@(posedge clk);
																							@(posedge clk);
		//write and read over the max memory capacity 
		write <= 1; read <= 0; 			repeat(25) 										@(posedge clk);
		write <= 0; read <= 1; 			repeat(25) 										@(posedge clk);
		
		//write and read one after another
		write <= 1; read <= 0; 			repeat(10) 										@(posedge clk);
		write <= 0; read <= 1; 			repeat(10)										@(posedge clk);
	$stop;
	end
endmodule 