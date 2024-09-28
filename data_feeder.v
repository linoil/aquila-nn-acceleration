module data_feeder#( parameter XLEN = 32)
(
    input                   clk_i,
    input                   rst_i,
    input                   dsa_sel_i,
    input                   dsa_strobe_i,
    input                   dsa_we_i,
    input [XLEN-1 : 0]      addr_i,
    input [XLEN-1 : 0]      data_i,
    output reg [XLEN-1 : 0] data_o,
    output reg              dsa_ready_o
);

wire [XLEN-1 : 0] result;
reg [XLEN-1 : 0] data_a;
reg [XLEN-1 : 0] data_b;
reg [XLEN-1 : 0] data_c;

reg is_CAL;
reg input_valid;
wire result_valid;

always @(posedge clk_i) begin
    if (rst_i) begin
        is_CAL <= 0;
        data_o <= 0;
    end
    else if (input_valid) begin
        is_CAL <= 1;
        data_o <= data_o;
    end
    else if (result_valid) begin
        is_CAL <= 0;
        data_o <= result;
    end
    else begin
        is_CAL <= is_CAL;
        data_o <= data_o;
    end
end

always @(posedge clk_i) begin
    if (rst_i) begin
        dsa_ready_o <= 0;
    end
    else if (dsa_sel_i && dsa_strobe_i && !is_CAL) begin
        dsa_ready_o <= 1;
    end
    else if (result_valid && is_CAL) begin
        dsa_ready_o <= 1;
    end
    else begin
        dsa_ready_o <= 0;
    end
end

always @(posedge clk_i) begin
    if (rst_i) begin
        input_valid <= 0;
    end
    else if (input_valid) begin
        input_valid <= 0;
    end
    else if (dsa_sel_i && dsa_strobe_i) begin
        if (addr_i == 32'hC4000000) begin
            data_a <= data_i;
        end
        else if (addr_i == 32'hC4000004) begin
            data_b <= data_i;
        end
        else if (addr_i == 32'hC4000008) begin
            data_c <= data_i;
            input_valid <= 1;
        end
        else begin
            data_a <= data_a;
            data_b <= data_b;
            data_c <= data_c;
        end
    end
    else begin
        data_a <= data_a;
        data_b <= data_b;
        data_c <= data_c;
        input_valid <= input_valid;
    end
end


floating_point_0 inner_product_1(
    .aclk(clk_i),                   // input wire aclk
    .s_axis_a_tvalid(input_valid),  // input wire s_axis_a_tvalid
    .s_axis_a_tdata(data_a),        // input wire [31 : 0] s_axis_a_tdata
    .s_axis_b_tvalid(input_valid),  // input wire s_axis_b_tvalid
    .s_axis_b_tdata(data_b),        // input wire [31 : 0] s_axis_b_tdata
    .s_axis_c_tvalid(input_valid),  // input wire s_axis_c_tvalid
    .s_axis_c_tdata(data_c),        // input wire [31 : 0] s_axis_c_tdata
    .m_axis_result_tvalid(result_valid),  // output wire m_axis_result_tvalid
    .m_axis_result_tdata(result)    // output wire [31 : 0] m_axis_result_tdata
); 


endmodule