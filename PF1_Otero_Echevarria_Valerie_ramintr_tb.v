`include "PF1_Otero_Echevarria_Valerie_ram.v"
module ramintr_tb;

integer file, fw, code, i; reg [31:0] data;
reg Enable;
reg [31:0] Address; wire [31:0] DataOut;

inst_ram256x8 ram1 (DataOut, Enable, Address );

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
    Enable = 1'b0; 
    Address = #1 32'b00000000000000000000000000000000; //make sure adress is in 0 after precharge
    repeat (4) begin
    #5 Enable = 1'b1;
    #5 Enable = 1'b0;
    Address = Address + 4;
end
$finish;
end
always @ (posedge Enable)
    begin
    #1;   
    $fdisplay(fw,"Data en %d = %h %d", Address, DataOut, $time);
end
endmodule