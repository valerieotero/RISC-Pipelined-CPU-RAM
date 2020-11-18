`include "PF1_Otero_Echevarria_Valerie_ram.v"
module ramintr_tb;

integer file, fw, code, i; reg [31:0] data;
reg clk, Reset;
reg [31:0] Address; wire [31:0] DataOut;

inst_ram256x8 ram1 (DataOut, Address, Reset);

initial
    begin
    file = $fopen("PF1_Otero_Echevarria_Valerie_ramintr.txt","rb");
    Address = 32'b00000000000000000000000000000000;
        while (!$feof(file)) begin //while not the end of file
        code = $fscanf(file, "%b", data);
        ram1.Mem[Address] = data;
        Address = Address + 1;
    end

$fclose(file);  
end

initial begin
    fw = $fopen("inst_memcontent.txt", "w");    
    Address = #1 32'b00000000000000000000000000000000; //make sure adress is in 0 after precharge
    clk = 1'b0; 
    //Reset = 1'b0;
   
  /*  repeat (4) begin 
    #1 Reset = 1'b1;        
    #1 clk = 1'b1;
    #1 Reset = 1'b0;   
    #1 clk = 1'b0;           
end */

    repeat (17) begin
    #1 clk = 1'b1;
    #1 clk = 1'b0;
    Address = Address + 4;    
end
$finish;
end 
always @ (clk)
    begin
    #1;   
    $fdisplay(fw,"Data en %d = %b %d", Address, DataOut, $time);
end
endmodule