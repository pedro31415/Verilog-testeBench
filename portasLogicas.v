module portasLogicas(
	input [2:0] a,b,
	output [2:0] s1,s2,s3,s4,s5,s6,s7,
	output s8
);

assign s1 = a & b;
assign s2 = a | b;
assign s3 = ~a;
assign s4 = ~(a & b);
assign s5 = ~(a | b);
assign s6 = a ^ b;
assign s7 = ~(a ^ b);
assign s8 = !(a & b);

endmodule 