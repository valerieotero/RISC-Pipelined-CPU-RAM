`include "mem.v"
module data_mem_tb;

integer file, fw, code, i; reg [31:0] data;
reg Enable, ReadWrite; reg[31:0]DataIn;
reg [31:0] Address; wire [31:0] DataOut;
data_ram256x8 ram1 (DataOut, Enable, ReadWrite, Address, DataIn);

//Pre-charge memory
initial begin
    file = $fopen("data_input_file.txt","rb");
    Address = 32'b00000000000000000000000000000000;
        while (!$feof(file)) begin //while not the end of file
        code = $fscanf(file, "%b", data);
        ram1.Mem[Address] = data;
        Address = Address + 1;
    end

$fclose(file);
end

initial begin
    fw = $fopen("data_memcontent.txt", "w");
    Enable = 1'b0; ReadWrite = 1'b0;
    Address = #1 32'b00000000000000000000000000000000; //make sure adress is in 0 after precharge
    repeat (18) begin
    #5 Enable = 1'b1;
    #5 Enable = 1'b0;
    Address = Address + 1;
end
$finish;
end
always @ (posedge Enable)
    begin
    #1;   
    $fdisplay(fw,"ReadWrite: %d -- Address: %d -- DataIn: %b -- DataOut: %b-- Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
end
endmodule