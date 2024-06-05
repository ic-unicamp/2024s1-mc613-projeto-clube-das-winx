module ConversorBinario7Segmentos(
    input [23:0] BCD,
    output reg [6:0] digito0,
    output reg [6:0] digito1,
    output reg [6:0] digito2,
    output reg [6:0] digito3,
    output reg [6:0] digito4,
    output reg [6:0] digito5
);

integer k;
reg [41:0] valor_bcd;
reg [19:0]copia_BCD;

always @(*) begin
	valor_bcd = 42'b0;
	copia_BCD = BCD;
   for(k = 0; k < 6; k = k + 1) begin
      valor_bcd = valor_bcd << 7;
      case(copia_BCD[3:0])
        0: valor_bcd[6:0] = 'b1000000;
        1: valor_bcd[6:0] = 'b1111001;
        2: valor_bcd[6:0] = 'b0100100;
        3: valor_bcd[6:0] = 'b0110000;
        4: valor_bcd[6:0] = 'b0011001;
        5: valor_bcd[6:0] = 'b0010010;
        6: valor_bcd[6:0] = 'b0000010;
        7: valor_bcd[6:0] = 'b1111000;
        8: valor_bcd[6:0] = 'b0000000;
        9: valor_bcd[6:0] = 'b0010000;
      endcase
    copia_BCD = copia_BCD >> 4;

    end
        digito0 = valor_bcd[41:35];
        digito1 = valor_bcd[34:28];
        digito2 = valor_bcd[27:21];
        digito3 = valor_bcd[20:14];
        digito4 = valor_bcd[13:7];
        digito5 = valor_bcd[6:0];
end

endmodule