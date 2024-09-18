// ************************************************************************************************
//
// Copyright(C) 2022 ACCELR
// All rights reserved.
//
// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF
// ACCELER LOGIC (PVT) LTD, SRI LANKA.
//
// This copy of the Source Code is intended for ACCELR's internal use only and is
// intended for view by persons duly authorized by the management of ACCELR. No
// part of this file may be reproduced or distributed in any form or by any
// means without the written approval of the Management of ACCELR.
//
// ACCELR, Sri Lanka            https://accelr.lk
// No 175/95, John Rodrigo Mw,  info@accelr.net
// Katubedda, Sri Lanka         +94 77 3166850
//
// ************************************************************************************************
//
// PROJECT      :   Round robin arbiter
// PRODUCT      :   N/A
// FILE         :   round_robin_arbitor.sv
// AUTHOR       :   Praveen Alahakoon
// DESCRIPTION  :   Abitration logic module
//
// ************************************************************************************************
//
// REVISIONS:
//
//  Date            Developer           Description
//  -----------     ---------           -----------
//  18-SEP-2024     praveena-accelr     creation
//
//**************************************************************************************************

`timescale 1ns / 1ps

module round_robin_arbitor(
    clock,
    aresetn,
    request,
    done,
    grant
);

// Parameters
localparam   SLAVE_COUNT     = 4;

// Inputs and outputs
input wire                          clock;
input wire                          aresetn;
input wire      [SLAVE_COUNT-1: 0]  request;
input wire      [SLAVE_COUNT-1: 0]  done;
output logic    [SLAVE_COUNT-1: 0]  grant;

// Internal memories
logic   [$clog2(SLAVE_COUNT)-1:0]   current_ptr;
logic   [$clog2(SLAVE_COUNT)-1:0]   current_ptr_l2;
logic   [$clog2(SLAVE_COUNT)-1:0]   next_ptr;

always_ff @(posedge clock) begin
    if(!aresetn) begin
        current_ptr <= 0;
    end
    else begin
        current_ptr <= next_ptr;
    end
end

always_ff @(posedge clock) begin
    if(!aresetn) begin
        next_ptr <= 0;
    end
    else begin
        if(done[current_ptr_l2] && grant[current_ptr_l2]) begin
            next_ptr <= next_ptr + 1;
        end
    end
end

always_comb begin
    if(!aresetn) begin
        current_ptr_l2 = 0;
        grant = '0;
    end
    else begin
        case(current_ptr)
            2'b00 : begin
                if(request[0]) begin
                    grant = 4'b0001;
                    current_ptr_l2 = 0;
                end else if(request[1]) begin
                    grant = 4'b0010;
                    current_ptr_l2 = 1;
                end else if(request[2]) begin
                    grant = 4'b0100;
                    current_ptr_l2 = 2;
                end else if(request[3]) begin
                    grant = 4'b1000;
                    current_ptr_l2 = 3;
                end else
                    grant = '0;
                
            end
            2'b01 : begin
                if(request[1]) begin
                    grant = 4'b0010;
                    current_ptr_l2 = 1;
                end else if(request[2]) begin
                    grant = 4'b0100;
                    current_ptr_l2 = 2;
                end else if(request[3]) begin
                    grant = 4'b1000;
                    current_ptr_l2 = 3;
                end else if(request[0]) begin
                    grant = 4'b0001;
                    current_ptr_l2 = 0;
                end else 
                    grant = '0;
            end
            2'b10 : begin
                if(request[2]) begin
                    grant = 4'b0100;
                    current_ptr_l2 = 2;
                end else if(request[3]) begin
                    grant = 4'b1000;
                    current_ptr_l2 = 3;
                end else if(request[0]) begin
                    grant = 4'b0001;
                    current_ptr_l2 = 0;
                end else if(request[1]) begin
                    grant = 4'b0010;
                    current_ptr_l2 = 1;
                end else 
                    grant = '0;
            end
            2'b11 : begin
                if(request[3]) begin
                    grant = 4'b1000;
                    current_ptr_l2 = 3;
                end else if(request[0]) begin
                    grant = 4'b0001;
                    current_ptr_l2 = 0;
                end else if(request[1]) begin
                    grant = 4'b0010;
                    current_ptr_l2 = 1;
                end else if(request[2]) begin
                    grant = 4'b0100;
                    current_ptr_l2 = 2;
                end else 
                    grant = '0;
            end
        endcase
    end
end

endmodule