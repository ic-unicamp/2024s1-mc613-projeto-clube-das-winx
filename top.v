module top (
    input CLOCK_50,  // Clock de entrada de 50 MHz
    input [3:0] KEY,      // Sinal de reset
	 input [9:0] SW,
	 output [6:0] HEX0,
	 output [6:0] HEX1,
	 output [6:0] HEX2,
	 output [6:0] HEX3,
	 output [6:0] HEX4,
	 output [6:0] HEX5,
	 output reg clk_out_1,
	 output reg clk_out_2
);

    reg [25:0] count;
	 wire reset, cronometro_start, timer_function, timer_set, timer_start, cronometro_stop, plus, modeSeconds, modeMinutes, modeHours;
	 wire [23:0] bcd1, bcd2, bcd3;
	 reg [6:0] seconds_reg_timer, minutes_reg_timer, hours_reg_timer, seconds_reg_cronometro, minutes_reg_cronometro, hours_reg_cronometro, seconds_reg_timer_2, minutes_reg_timer_2, hours_reg_timer_2;

	 
    always @(posedge CLOCK_50) begin
        if (reset) begin
            count = 26'd0;
            clk_out_1 = 1'b0;
				clk_out_2 = 1'b0;
        end else begin
            if (count == 26'd24_999_999) begin
                count = 26'd0;
                clk_out_1 = ~clk_out_1;
					 clk_out_2 = ~clk_out_2;
            end else begin
                count = count + 1;
            end
        end
    end
	 
	 assign reset = ~KEY[0];
	 assign cronometro_start = SW[0];
	 assign timer_function = SW[1];
	 assign timer_set = ~KEY[1];
	 assign timer_start = SW[2];
	 assign cronometro_stop = ~SW[0];
	 assign plus = SW[7];
	 assign modeSeconds = ~SW[8] && ~SW[9];
	 assign modeMinutes = SW[8] && ~SW[9];
	 assign modeHours = SW[9];
	 
	 always @(posedge timer_set or posedge reset) begin
		if (reset) begin
            seconds_reg_timer = 7'b0000000;
				minutes_reg_timer = 7'b0000000;
				hours_reg_timer = 7'b0000000;
       end else if (timer_set) begin
			if (modeSeconds) begin
				if (seconds_reg_timer == 7'b0111011 && plus) begin
					seconds_reg_timer = 7'b0000000;
				end else if (seconds_reg_timer == 7'b0000000 && !plus) begin
					seconds_reg_timer = 7'b0111011;
				end else begin
					seconds_reg_timer = plus ? seconds_reg_timer + 1 : seconds_reg_timer - 1;
				end
			end else if (modeMinutes) begin
				if (minutes_reg_timer == 7'b0111011 && plus) begin
					minutes_reg_timer = 7'b0000000;
				end else if (minutes_reg_timer == 7'b0000000 && !plus) begin
					minutes_reg_timer = 7'b0111011;
				end else begin
					minutes_reg_timer = plus ? minutes_reg_timer + 1 : minutes_reg_timer - 1;
				end
			end else if (modeHours) begin
				if (hours_reg_timer == 7'b1100011 && plus) begin
					hours_reg_timer = 7'b0000000;
				end else if (hours_reg_timer == 7'b0000000 && modeHours && !plus) begin
					hours_reg_timer = 7'b1100011;
				end else begin
					hours_reg_timer = plus ? hours_reg_timer + 1 : hours_reg_timer - 1;
				end
			end
      end 
	 end
	     
    always @(posedge clk_out_2 or posedge reset) begin
        if (reset) begin
            seconds_reg_cronometro = 7'b0000000;
				minutes_reg_cronometro = 7'b0000000;
				hours_reg_cronometro = 7'b0000000;
				seconds_reg_timer_2 = 7'b0000000;
				minutes_reg_timer_2 = 7'b0000000;
				hours_reg_timer_2 = 7'b0000000;
        end else if (cronometro_start) begin
				if (hours_reg_cronometro == 7'b1100011) begin
					hours_reg_cronometro = 7'b0000000;
				end if (minutes_reg_cronometro == 7'b0111011) begin
                minutes_reg_cronometro = 7'b0000000;
					 hours_reg_cronometro = hours_reg_cronometro + 7'b0000001;
            end if (seconds_reg_cronometro == 7'b0111011) begin
                seconds_reg_cronometro = 7'b0000000;
					 minutes_reg_cronometro = minutes_reg_cronometro + 7'b0000001;
            end else begin
                seconds_reg_cronometro = seconds_reg_cronometro + 1;
            end
        end else if (timer_start) begin
			  if (seconds_reg_timer_2 == 0 && minutes_reg_timer_2 == 0 && hours_reg_timer_2 == 0) begin
					 seconds_reg_timer_2 = 7'b0000000;
           end else begin
					if (seconds_reg_timer_2 == 7'b0000000 && minutes_reg_timer_2 >= 0) begin
						seconds_reg_timer_2 = 7'b0111011;
						if (minutes_reg_timer_2 == 7'b0000000 && hours_reg_timer_2 > 0) begin
							minutes_reg_timer_2 = 7'b0111011;
							hours_reg_timer_2 = hours_reg_timer_2 - 7'b0000001;
						end else begin
							minutes_reg_timer_2 = minutes_reg_timer_2 - 7'b0000001;
						end
					end
					else begin
						seconds_reg_timer_2 = seconds_reg_timer_2 - 1;
					end
           end
		end else begin
			seconds_reg_timer_2 = seconds_reg_timer;
			minutes_reg_timer_2 = minutes_reg_timer;
			hours_reg_timer_2 = hours_reg_timer;
		end
    end
	 
	 conversor conversor1(
		 .bin((timer_function && !timer_start) ? seconds_reg_timer : timer_start ? seconds_reg_timer_2 : seconds_reg_cronometro),
		 .bcd(bcd1)
	);
	
	ConversorBinario7Segmentos ConversorBinario7Segmentos_segundos (
    .BCD(bcd1),
    .digito0(HEX0),
    .digito1(HEX1)
	);
	
	conversor conversor2(
		 .bin((timer_function && !timer_start) ? minutes_reg_timer : timer_start ? minutes_reg_timer_2 : minutes_reg_cronometro),
		 .bcd(bcd2)
	);
	
	ConversorBinario7Segmentos ConversorBinario7Segmentos_minutos (
    .BCD(bcd2),
    .digito0(HEX2),
    .digito1(HEX3)
	);
	
	conversor conversor3(
		 .bin((timer_function && !timer_start) ? hours_reg_timer : timer_start ? hours_reg_timer_2 : hours_reg_cronometro),
		 .bcd(bcd3)
	);
	
	ConversorBinario7Segmentos ConversorBinario7Segmentos_horas (
    .BCD(bcd3),
    .digito0(HEX4),
    .digito1(HEX5)
	);

endmodule
