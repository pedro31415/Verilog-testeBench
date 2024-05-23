`timescale 10ns/1ns;

module portasLogicas_Testador;
	reg [2:0] a,b;
	wire [2:0] s1,s2,s3,s4,s5,s6,s7;
	wire s8;
	
	portasLogicas uut (.a(a), .b(b), .s1(s1), .s2(s2), .s3(s3), .s4(s4), .s5(s5), .s6(s6), .s7(s7), .s8(s8));
	initial begin 
	a = 3'b000;
	b = 3'b000;
	
	#20
	a = 3'b010;
	b = 3'b011;
	
	#40
	a = 3'b110;
	b = 3'b101;
	
	#50
	a = 3'b101;
	b = 3'b110;
	
	#60
	a = 3'b111;
	b = 3'b000;
	
	#20
	a = 3'b111;
	b = 3'b111;
	
	#100
	$stop;
	end 
endmodule 