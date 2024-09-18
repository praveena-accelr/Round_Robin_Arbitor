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
// DESCRIPTION  :   Test bench module
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

module tb_rr_arbitor();

logic              clock;
logic              aresetn;
logic   [3: 0]     request;
logic   [3: 0]     done;
logic   [3: 0]     grant;

// Module instantiation
round_robin_arbitor uut(
    .clock(clock),
    .aresetn(aresetn),
    .request(request),
    .done(done),
    .grant(grant)
);

// Initial block for runing the test cases
initial begin
    clock = 0;
    request = '0;
    done = '0;
    aresetn = 1;
    #1;
    aresetn = 0;
    #2;
    aresetn = 1;
    #2;

    // Test case 1
    request = 4'b0001;
    #10;
    done = 4'b0001;
    #2;
    done = '0;

    // Test case 2
    request = 4'b1001;
    #10;
    done = 4'b1000;
    #2;
    done = '0;
    
    // Test case 3
    request = 4'b1011;
    #10;
    done = 4'b1000;
    #2;
    done = 0;

    // Test case 4
    request = 4'b1111;
    #10;
    done = 4'b1000;
    #2;
    done = 0;

    // Test case 5
    request = 4'b1001;
    #10;
    done = 4'b0001;
    #2;
    done = 0;

    // End simulation
    $display("Simulation finished");
    $finish;
end

// clock generation
always begin
    clock = ~clock;
    #1;
end

endmodule