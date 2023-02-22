//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2021 ICLAB Spring Course
//   Lab06			: Series Processing (SP)
//   Author         : Shiuan-Yun Ding (mirkat.ding@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : SP_wocg.v
//   Module Name : SP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module SP_wocg(
	// Input signals
	clk,
	rst_n,
	in_valid,
	in_data,
	in_mode,
	// Output signals
	out_valid,
	out_data
);
//================================================================
//  INPUT AND OUTPUT DECLARATION                         
//================================================================
input clk, rst_n, in_valid;
input [2:0] in_mode;
input [8:0] in_data;
output reg out_valid;
output reg [8:0] out_data;
//================================================================
//  integer / genvar  / parameter
//================================================================
genvar idx;
integer i;
localparam IDLE = 4'b0000;
localparam INV  = 4'b0001;
localparam MUL  = 4'b0010;
localparam SORT = 4'b0100;
localparam SUM  = 4'b1000;

//================================================================
//  reg / wire
//================================================================
reg [3:0] cur_state,next_state;
reg [4:0] cnt;
reg [2:0] cnt_data;
reg [8:0] data_temp;
reg [10:0] data_sum [0:5]; 
reg [2:0] mode_r;

//wire 
wire idle_state = cur_state == IDLE;

//IO
wire inv_in_valid  = cur_state[0] && cnt < 6;
wire mul_in_valid  = cur_state[1] && cnt < 6;
wire sort_in_valid = cur_state[2] && cnt < 6;
wire sum_in_valid  = cur_state[3] && cnt < 6;

wire inv_out_valid,mul_out_valid,sort_out_valid;
wire [8:0] inv_out_data,mul_out_data,sort_out_data;

wire [8:0] sum_mod_out_w;  //Modular_509

//flag
wire inv_done  = cur_state[0] && cnt == 'd18;
wire mul_done  = cur_state[1] && cnt == 'd12;
wire sort_done = cur_state[2] && cnt == 'd11;
reg  sum_done ;
wire mode0_cnt_flag = cur_state[3] && mode_r == 'd0 && cnt == 'd5;

//================================================================
//  FSM
//================================================================

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cur_state <= IDLE;
	end
	else begin
		cur_state <= next_state;
	end
end

always @(*) begin
	case(cur_state)
		IDLE : next_state = in_valid  ? in_mode[0] ? INV : in_mode[1] ? MUL : in_mode[2] ? SORT : SUM : IDLE;
		INV  : next_state = inv_done  ? mode_r[1] ? MUL : mode_r[2] ? SORT : SUM : INV;
		MUL  : next_state = mul_done  ? mode_r[2] ? SORT : SUM : MUL;
		SORT : next_state = sort_done ? SUM : SORT;
		SUM  : next_state = sum_done  ? IDLE : SUM;
	endcase
end

//================================================================
//  DESIGN
//================================================================

//sum_done
always @(*) begin 
	if(cur_state[3]) begin
		if(mode_r == 'd0) sum_done = cnt == 'd12;
		else sum_done = cnt == 'd7;
	end
	else sum_done = 0;
end

//cnt
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cnt <= 'd0;
	end
	else begin
		if(idle_state) cnt <= 'd0;
		else if(inv_done | mul_done | sort_done) cnt <= 'd0;
		else cnt <= cnt + 'd1;
	end
end

//cnt_data
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cnt_data <= 'd0;
	end
	else begin
		if(inv_in_valid)  cnt_data <= cnt_data + 'd1;
		else if(mul_in_valid)  cnt_data <= cnt_data + 'd1;
		else if(sort_in_valid) cnt_data <= cnt_data + 'd1;
		else if(mode0_cnt_flag) cnt_data <= 'd1;
		else if(cur_state[3])  cnt_data <= cnt_data + 'd1;
		else if(inv_done | mul_done | sort_done | sum_done) cnt_data <= 'd0;
	end
end

//mode_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		mode_r <= 'd0;
	end
	else if(in_valid && idle_state)begin
		mode_r <= in_mode;
	end
end

//data_temp
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		data_temp <= 'd0;
	end
	else begin
		if(in_valid) data_temp <= in_data;
		else if(inv_out_valid)  data_temp <= inv_out_data;
		else if(mul_out_valid)  data_temp <= mul_out_data;
		else if(sort_out_valid) data_temp <= sort_out_data;
	end
end

//data_sum
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for(i=0;i<6;i=i+1) begin
			data_sum[i] <= 'd0;
		end
	end
	else begin
		if(inv_in_valid) begin
			data_sum[cnt_data] <= data_sum[cnt_data] + data_temp;  //a
		end
		else if(mul_in_valid)  begin 
			if(mode_r[0]) data_sum[cnt_data] <= data_sum[cnt_data] + data_temp;  //b
			else data_sum[cnt_data] <= data_sum[cnt_data] + (data_temp << 1);  //2a
		end
		else if(sort_in_valid) begin
			if(mode_r[1:0] == 'd0) data_sum[cnt_data] <= (data_sum[cnt_data] + data_temp) + (data_temp << 1);  //3a
			else if(mode_r[1]) data_sum[cnt_data] <= data_sum[cnt_data] + data_temp; //c
			else data_sum[cnt_data] <= data_sum[cnt_data] + (data_temp << 1); //2b
		end
		else if(sum_in_valid)  begin
			if(mode_r[2:0] == 'd0) data_sum[cnt_data] <= data_sum[cnt_data] + (data_temp << 2);  //4a
			else if(mode_r[2]) data_sum[cnt_data] <= data_sum[cnt_data] + data_temp; //d
			else if(mode_r[1]) data_sum[cnt_data] <= data_sum[cnt_data] + (data_temp << 1); //2c
			else data_sum[cnt_data] <= (data_sum[cnt_data] + data_temp) + (data_temp << 1); //3b
		end
		else if(idle_state) begin
			for(i=0;i<6;i=i+1) begin
				data_sum[i] <= 'd0;
			end
		end
	end
end

//out_data
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		out_data <= 'd0;
	end
	else begin
		if(sum_done) out_data <= 'd0;
		else if(cur_state[3]) begin 
			if(mode_r == 'd0) out_data <= cnt > 'd5 ? sum_mod_out_w : 'd0;
			else out_data <= cnt > 'd0 ? sum_mod_out_w : 'd0;
		end
	end
end

//out_valid
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		out_valid <= 0;
	end
	else begin
		if(sum_done) out_valid <= 0;
		else if(cur_state[3]) begin 
			if(mode_r == 'd0) out_valid <= cnt > 'd5 ? 1 : 0;
			else out_valid <= cnt > 'd0 ? 1 : 0;
		end
	end
end

//================================================================
//  Module 
//================================================================

Modular_Inv Inv_inst (.clk(clk),.rst_n(rst_n),.in_valid(inv_in_valid),.in_data(data_temp),.out_valid(inv_out_valid) ,.out_data(inv_out_data));
Modular_Mul Mul_inst (.clk(clk),.rst_n(rst_n),.in_valid(mul_in_valid),.in_data(data_temp),.out_valid(mul_out_valid) ,.out_data(mul_out_data));
Sort      Sort_inst (.clk(clk),.rst_n(rst_n),.in_valid(sort_in_valid),.in_data(data_temp),.out_valid(sort_out_valid),.out_data(sort_out_data));
Modular_509 U_inst_C(.in_data({7'd0,data_sum[cnt_data - 1]}),.out_data(sum_mod_out_w));

endmodule

module Modular_509(in_data,out_data);
parameter BIAS = 9'd509;
input [17:0] in_data;
output reg [8:0] out_data;
wire  [10:0] tmp = (in_data[8:0] + in_data[17:9]) + (in_data[17:9] << 1);
wire  [10:0] tmp_bias_509  = tmp - BIAS;
wire  [10:0] tmp_bias_1018 = tmp - (BIAS<<1);
wire  [10:0] tmp_bias_1527 = tmp - (BIAS<<1) - BIAS;
wire  [10:0] tmp_bias_2036 = tmp - (BIAS<<2);
always @(*) begin
	if(tmp < BIAS) out_data = tmp;
	else if(tmp_bias_509  < BIAS) out_data = tmp_bias_509 ;
	else if(tmp_bias_1018 < BIAS) out_data = tmp_bias_1018;
	else if(tmp_bias_1527 < BIAS) out_data = tmp_bias_1527;
	else out_data = tmp_bias_2036;
end

endmodule

module Modular_Inv(clk,rst_n,in_valid,in_data,out_valid,out_data);
input  [8:0] in_data;
input  clk,rst_n,in_valid;
output out_valid;
output [8:0] out_data;

localparam IDLE = 2'b00;
localparam CAL  = 2'b01;
localparam OUT  = 2'b10;

//reg
reg [1:0] cur_state,next_state;
reg [5:0] st_end_flag_r;
reg pulse;
reg [3:0] cnt;
reg [17:0] data_A_r[0:5],data_B_r[0:5];

//flag
wire cal_done = cnt == 'd12;
wire out_done = cnt == 'd5 && cur_state[1];
reg  [5:0] stall_flag_r;

//module_IO
wire  [8:0] modA_out_w[0:2];
wire  [8:0] modB_out_w[0:2];
reg  [17:0] modA_in_w [0:2];
reg  [17:0] modB_in_w [0:2];
wire [17:0] mulA_out_w[0:2];
wire [17:0] mulB_out_w[0:2];
reg   [8:0] mulA_in_w [0:2];
reg   [8:0] mulB_in_w [0:2];

//index
genvar idx;
integer i;

//output
assign out_valid = cur_state[1];
assign out_data = out_valid ? data_A_r[cnt] : 'd0;

//================================================================
//  FSM
//================================================================

//cur_state
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cur_state <= IDLE;
	end
	else begin
		cur_state <= next_state;
	end
end

//next_state
always @(*) begin
	case(cur_state)
		IDLE:next_state = in_valid ? CAL : IDLE;
		CAL :next_state = cal_done ? OUT : CAL ;
		OUT :next_state = out_done ? IDLE: OUT ;
		default: next_state = IDLE;
	endcase
end

//================================================================
//  DESIGN
//================================================================
generate
	for(idx=0;idx<3;idx=idx+1) begin
		Modular_509 U_inst_A(.in_data(modA_in_w[idx]),.out_data(modA_out_w[idx]));
		Modular_509 U_inst_B(.in_data(modB_in_w[idx]),.out_data(modB_out_w[idx]));
	end
endgenerate

generate
	for(idx=0;idx<3;idx=idx+1) begin
		assign mulA_out_w[idx] =  mulA_in_w[idx] * mulB_in_w[idx];
		assign mulB_out_w[idx] =  mulB_in_w[idx] * mulB_in_w[idx];
	end
endgenerate

//mulA_in_w
always @(*) begin 
	for(i=0;i<3;i=i+1) begin
		if(pulse)
			mulA_in_w[i] = data_A_r[2*i];
		else
			mulA_in_w[i] = data_A_r[2*i+1];
	end
end

//mulB_in_w
always @(*) begin 
	for(i=0;i<3;i=i+1) begin
		if(pulse)
			mulB_in_w[i] = data_B_r[2*i];
		else
			mulB_in_w[i] = data_B_r[2*i+1];
	end
end

//modA_in_w
always @(*) begin 
	for(i=0;i<3;i=i+1) begin
		if(!pulse)
			modA_in_w[i] = data_A_r[2*i];
		else
			modA_in_w[i] = data_A_r[2*i+1];
	end
end

//modB_in_w
always @(*) begin 
	for(i=0;i<3;i=i+1) begin
		if(!pulse)
			modB_in_w[i] = data_B_r[2*i];
		else
			modB_in_w[i] = data_B_r[2*i+1];
	end
end

//cnt
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cnt <= 'd0;
	end
	else begin
		if(in_valid) cnt <= cnt + 'd1;
		else if(cal_done | out_done) cnt <= 'd0;
		else if(cur_state[1]) cnt <= cnt + 'd1;
		else if(pulse) cnt <= cnt + 'd1;
	end
end

//stall_flag_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		stall_flag_r <= 'd0;
	end
	else begin
		if(cnt == 'd3 && cur_state[0]) stall_flag_r <= 6'b000001;
		else if(cnt == 'd4 && cur_state[0]) stall_flag_r <= 6'b000011;
		else stall_flag_r <= stall_flag_r << 1;
	end
end

//pulse
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		pulse <= 0;
	end
	else begin
		if(out_done) pulse <= 0;
		else if(cur_state[0] | cur_state[1]) pulse <= ~pulse;
	end
end

//st_end_flag_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		st_end_flag_r <= 'd0;
	end
	else begin
		if(in_valid) st_end_flag_r[cnt] <= 1;
		else if(cur_state[1]) st_end_flag_r[cnt] <= 0;
	end
end

//data_A_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for(i=0;i<6;i=i+1) begin
			data_A_r[i] <= 'd0;
		end
	end
	else begin
		for(i=0;i<6;i=i+2) begin //even
			if(in_valid && cnt == i)  data_A_r[i] <= in_data;
			else if(stall_flag_r[i])  data_A_r[i] <= data_A_r[i];
			else if(st_end_flag_r[i]) data_A_r[i] <= !pulse ? modA_out_w[i>>1] : mulA_out_w[i>>1];
			else data_A_r[i] <= 'd0;
		end
		for(i=1;i<6;i=i+2) begin //odd
			if(in_valid && cnt == i)  data_A_r[i] <= in_data;
			else if(stall_flag_r[i])  data_A_r[i] <= data_A_r[i];
			else if(st_end_flag_r[i]) data_A_r[i] <= !pulse ? mulA_out_w[i>>1] : modA_out_w[i>>1];
			else data_A_r[i] <= 'd0;
		end
	end
end

//data_B_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for(i=0;i<6;i=i+1) begin
			data_B_r[i] <= 'd0;
		end
	end
	else begin
		for(i=0;i<6;i=i+2) begin //even
			if(in_valid && cnt == i) data_B_r[i] <= in_data*in_data;
			else if(st_end_flag_r[i]) data_B_r[i] <= !pulse ? modB_out_w[i>>1] : mulB_out_w[i>>1] ;
			else data_B_r[i] <= 'd0;
		end
		for(i=1;i<6;i=i+2) begin //odd
			if(in_valid && cnt == i) data_B_r[i] <= in_data*in_data;
			else if(st_end_flag_r[i]) data_B_r[i] <= !pulse ? mulB_out_w[i>>1] : modB_out_w[i>>1];
			else data_B_r[i] <= 'd0;
		end
	end
end

endmodule

module Modular_Mul(clk,rst_n,in_valid,in_data,out_valid,out_data);
input  [8:0] in_data;
input  clk,rst_n,in_valid;
output out_valid;
output [8:0] out_data;

localparam IDLE = 2'b00;
localparam CAL  = 2'b01;
localparam OUT  = 2'b10;

reg [1:0] cur_state,next_state;
reg [3:0] cnt;
reg [8:0] b_r[0:5];
reg [8:0] tmp_mod_r;
reg [8:0] tmp1_r;
reg [8:0] tmp2_r;
reg [8:0] tmp3_r;
reg [8:0] tmp4_r;
reg [17:0] tmp_r;

//index
genvar idx;
integer i;

//IO
wire [8:0] mod_out_w;
reg  [8:0] in_mul_A_w,in_mul_B_w;
Modular_509 U_inst_C(.in_data(tmp_r),.out_data(mod_out_w));

//output
assign out_valid = cur_state[1];
assign out_data  = out_valid ? tmp_mod_r : 'd0;
//================================================================
//  FSM
//================================================================

//cur_state
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cur_state <= IDLE;
	end
	else begin
		cur_state <= next_state;
	end
end

//next_state
always @(*) begin
	case(cur_state)
		IDLE:next_state = in_valid ? CAL : IDLE;
		CAL :next_state = cnt == 'd10 ? OUT : CAL ;
		OUT :next_state = cnt == 'd0 ? IDLE: OUT ;
		default: next_state = IDLE;
	endcase
end
//================================================================
//  DESIGN
//================================================================

//in_mul_A_w
always @(*) begin
	if(in_valid) begin
		in_mul_A_w = b_r[0];
	end
	else begin
		case(cnt)
			'd5 :in_mul_A_w = b_r[0];
			'd6 :in_mul_A_w = tmp_mod_r;
			'd7 :in_mul_A_w = tmp2_r;
			'd8 :in_mul_A_w = tmp1_r;
			'd9 :in_mul_A_w = b_r[0];
			'd10:in_mul_A_w = b_r[1];
			'd11:in_mul_A_w = b_r[2];
			'd12:in_mul_A_w = b_r[3];
			'd13:in_mul_A_w = b_r[4];
			'd14:in_mul_A_w = b_r[5];
			default:in_mul_A_w = 'd0;
		endcase
	end
end

//in_mul_B_w
always @(*) begin
	if(in_valid) begin
		in_mul_B_w = in_data;
	end
	else begin
		case(cnt)
			'd5 :in_mul_B_w = b_r[5];
			'd6 :in_mul_B_w = tmp4_r;
			'd7 :in_mul_B_w = tmp4_r;
			'd8 :in_mul_B_w = tmp4_r;
			'd9 :in_mul_B_w = tmp_mod_r;
			'd10:in_mul_B_w = tmp_mod_r;
			'd11:in_mul_B_w = tmp3_r;
			'd12:in_mul_B_w = tmp3_r;
			'd13:in_mul_B_w = tmp1_r;
			'd14:in_mul_B_w = tmp2_r;
			default:in_mul_B_w = 'd0;
		endcase
	end
end

//cnt
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cnt <= 'd0;
	end
	else begin
		if(cur_state[0] | cur_state[1]) cnt <= cnt + 'd1; 
		else if(cur_state == IDLE) cnt <= 'd0;
	end
end

//b_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for(i=0;i<6;i=i+1) begin
			b_r[i] <= 'd0;
		end
	end
	else begin
		if(in_valid) begin
			for(i=0;i<5;i=i+1) begin
				b_r[0] <= in_data;
				b_r[i+1] <= b_r[i];
			end
		end
	end
end

//tmp_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		tmp_r <= 'd0;
	end
	else begin
		tmp_r <= in_mul_A_w * in_mul_B_w;
	end
end

//tmp_mod_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		tmp_mod_r <= 'd0;
	end
	else begin
		tmp_mod_r <= mod_out_w;
	end
end

//tmp1_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		tmp1_r <= 'd0;
	end
	else begin
		tmp1_r <= cur_state[1] ? tmp1_r : tmp_mod_r;
	end
end

//tmp2_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		tmp2_r <= 'd0;
	end
	else begin
		tmp2_r <= cur_state[1] ? tmp2_r : tmp1_r;
	end
end

//tmp3_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		tmp3_r <= 'd0;
	end
	else begin
		tmp3_r <= cur_state[1] ? tmp3_r : tmp2_r;
	end
end

//tmp4_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		tmp4_r <= 'd0;
	end
	else begin
		tmp4_r <= tmp3_r;
	end
end

endmodule

module Sort(clk,rst_n,in_valid,in_data,out_valid,out_data);
input  [8:0] in_data;
input  clk,rst_n,in_valid;
output out_valid;
output [8:0] out_data;

integer i;
reg [8:0] data_r[0:5];
reg [4:0] st_flag_r;
reg [1:0] cur_state,next_state;

localparam IDLE = 2'b00;
localparam RD   = 2'b01;
localparam SORT = 2'b10;
localparam OUT  = 2'b11;

//flag
wire sort_done = st_flag_r == 'd1 && cur_state == SORT;
wire rd_done = st_flag_r[0] && cur_state == RD;
wire out_done = st_flag_r == 0 && cur_state == OUT;

//output
assign out_valid = cur_state == OUT;
assign out_data  = out_valid ? data_r[5] : 'd0;

//================================================================
//  FSM
//================================================================

//cur_state
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cur_state <= IDLE;
	end
	else begin
		cur_state <= next_state;
	end
end

//next_state
always @(*) begin
	case(cur_state)
		IDLE:next_state = in_valid  ? RD   : IDLE;
		RD  :next_state = rd_done   ? SORT : RD  ;
		SORT:next_state = sort_done ? OUT  : SORT;
		OUT: next_state = out_done  ? IDLE : OUT ;
		default: next_state = IDLE;
	endcase
end

//================================================================
//  DESIGN
//================================================================

//st_flag_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		st_flag_r <= 'd0;
	end
	else if (cur_state == IDLE || sort_done) begin
		st_flag_r <= 'b10000;
	end
	else if(rd_done) begin
		st_flag_r <= 'b10101;
	end
	else begin
		st_flag_r <= st_flag_r >> 1;
	end
end

//data_r
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for(i=0;i<6;i=i+1) begin
			data_r[i] <= 'd0;
		end
	end
	else begin
		if(in_valid) begin
			if(in_data > data_r[0]) begin
				data_r[0] <= in_data;
				data_r[1] <= data_r[0];
				data_r[2] <= data_r[1];
				data_r[3] <= data_r[2];
				data_r[4] <= data_r[3];
				data_r[5] <= data_r[4];
			end
			else begin
				data_r[1] <= in_data;
				data_r[2] <= data_r[1];
				data_r[3] <= data_r[2];
				data_r[4] <= data_r[3];
				data_r[5] <= data_r[4];
			end
		end
		else if(cur_state == SORT && st_flag_r[0]) begin  //data[0] > data[1] ....data[5]
      		for(i=1;i<5;i=i+2)
      		begin
      		  data_r[i  ] <= (data_r[i] < data_r[i+1]) ? data_r[i+1] : data_r[i  ];
      		  data_r[i+1] <= (data_r[i] < data_r[i+1]) ? data_r[i  ] : data_r[i+1];
      		end
		end
		else if(cur_state == SORT && !st_flag_r[0]) begin
      		for(i=2;i<5;i=i+2)
      		begin
      		  data_r[i  ] <= (data_r[i] < data_r[i+1]) ? data_r[i+1] : data_r[i  ];
      		  data_r[i+1] <= (data_r[i] < data_r[i+1]) ? data_r[i  ] : data_r[i+1];
      		end
		end
		else if(cur_state == OUT) begin
      		for(i=0;i<5;i=i+1)
      		begin
      		  data_r[i+1] <= data_r[i];
      		end
		end
		else if(cur_state == IDLE) begin
			for(i=0;i<6;i=i+1) begin
				data_r[i] <= 'd0;
			end
		end
	end
end

endmodule
