// Ashika Palacharla
// Nithya Subramanian
// 1/28/2025
// EE371
// Lab 2 Task 3: FIFO Design

// Module seg7_hex is a 7-segment display driver for HEX values 0 through F.
// It produces the LED output for a 7-bit hex display, based on the
// given hex value. HEX display is active-low. 
// The module inputs are: 4-bit hex.
// The module outputs are: 7-bit leds.
module seg7_hex (val, display);
	input logic [3:0] val;
	output logic [6:0] display;
	
	//Make hex display with all options of the hex inputs
	//16 rows, 7 bits each --> 16 hexadecimal values, each with 7 bit LED display
	logic [15:0][6:0] hex_display;
	assign hex_display[0]  = 7'b1000000; // 0
	assign hex_display[1]  = 7'b1111001; // 1
	assign hex_display[2]  = 7'b0100100; // 2
	assign hex_display[3]  = 7'b0110000; // 3
	assign hex_display[4]  = 7'b0011001; // 4
	assign hex_display[5]  = 7'b0010010; // 5
	assign hex_display[6]  = 7'b0000010; // 6
	assign hex_display[7]  = 7'b1111000; // 7
	assign hex_display[8]  = 7'b0000000; // 8
	assign hex_display[9]  = 7'b0010000; // 9
	assign hex_display[10] = 7'b0001000; // A
	assign hex_display[11] = 7'b0000011; // B
	assign hex_display[12] = 7'b1000110; // C
	assign hex_display[13] = 7'b0100001; // D
	assign hex_display[14] = 7'b0000110; // E
	assign hex_display[15] = 7'b0001110; // F
	
	//Assign hex_displays to HEX5-HEX4 for address, HEX2 for data in, HEX0 for data out
	//Based on the value of address, data in, and data out
	assign display = hex_display[val];
	
endmodule //seg7_hex

//Testbench for seg7_hex that simulates all scenarios
module seg7_hex_testbench();
	logic [3:0] val;
	logic [6:0] display;
	
	hex_driver dut (.val(val), .display(display));
	
	initial begin
	// Test some random inputs
		
		val = 4'b0000; 
		
		#10;
		val = 4'b0001;
		
		#10;
		val = 4'b0011;
		
		#10;
		val = 4'b0111;
		
		#10;
		val = 4'b1111;
		
		$stop;
	end
endmodule 