/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_Digi_OTA_Analo (
    input  wire       VGND,
    input  wire       VDPWR,    // 1.8v power supply
//    input  wire       VAPWR,    // 3.3v power supply
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    inout  wire [7:0] ua,       // Analog pins, only ua[5:0] can be used
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    wire Vip, Vin, Out;

    assign Vip = ui_in[0];
    assign Vin = ui_in[1];
    
    assign uo_out[0]  = Out;  
    assign uo_out[7:1] = 7'b0000000; 

    wire INn, INp, INn_CMP, INp_CMP, CMP, EN, not_EN, Op, On, INn_AND, INp_AND; //internals nets 
    not IV1(INn, Vip);    
    not INV2(INn_CMP,CMP);
    not IV3(INp, Vin);
    not INV4(INp_CMP,CMP);

    nor NOR1(Op, INn, INn_CMP);
    nor NOR2(On, INp, INp_CMP);
    
    //not IV5(Op, INn_AND);
    //not IV6(On, INp_AND);
    
    xor XOR1(EN, Op, On);
    
    not IV7(not_EN, EN);
    notif1 IT1(CMP, not_EN, Op);  
    
    bufif1 BT1(Out, EN, Op);   

    
  

endmodule
