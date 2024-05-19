`timescale 10ns/1ns

module operadoresLogicosTeste;
	reg [3:0] a;
	wire s_logico;
	wire [3:0] s_negacao;
	
	operadoresLogicos uut (.a(a), .s_logico(s_logico), .s_negacao(s_negacao));
	
	initial begin 
	a = 4'b0000;
	#5
	
	a = 4'b1010;
	#5
	
	a = 4'b1100;
	#10
	
	a = 4'b0111;
	
	#100
	$stop;
	
	end
endmodule 