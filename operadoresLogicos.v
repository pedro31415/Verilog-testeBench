module operadoresLogicos(
	input [3:0] a,
	output s_logico,
	output [3:0] s_negacao
);

assign s_logico = !a;
assign s_negacao = ~a;

endmodule 