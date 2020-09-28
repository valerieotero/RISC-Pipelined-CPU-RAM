`include "mem.v"
module data_mem_tb;

integer file, fw, code, i; reg [31:0] data;
reg Enable, ReadWrite; reg[31:0]DataIn;
reg [31:0] Address; wire [31:0] DataOut; reg[1:0]Size;
data_ram256x8 ram1 (DataOut, Enable, ReadWrite, Address, DataIn, Size);

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
    Address = #1 32'b00000000000000000000000000000000; //make sure adress is in 0 after precharge
    Enable = 1'b0; ReadWrite = 1'b0; //Read  


    $fdisplay(fw, "-------------- Reading Word from Addresses 0, 4, 8 and 12 ----------------\n");   
    Size = 2'b10; //WORD
    ReadWrite = 1'b0; //Read
    repeat (4) begin          
        #5 Enable = 1'b1;
        #5 Enable = 1'b0;
        #1 $fdisplay(fw,"ReadWrite: %d -- Address: %d -- DataIn: %b -- DataOut: %b -- Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
        Address = Address + 4;
    end 


    $fdisplay(fw, "\n\n-------------- Reading Byte from Address 0 ----------------\n");   
    Size = 2'b00; //BYTE
    ReadWrite = 1'b0; //Read
    Address = 0;
    repeat (1) begin          
        #5 Enable = 1'b1;
        #5 Enable = 1'b0;
        #1 $fdisplay(fw,"ReadWrite: %d -- Address: %d -- DataIn: %b -- DataOut: %b -- Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
       // Address = Address + 1;
    end  

       
    $fdisplay(fw, "\n\n-------------- Reading Half-Word from Addresses 2 and 4 ----------------\n");   
    Size = 2'b01; //HALF-WORD
    ReadWrite = 1'b0; //Read
    Address = 2;
    repeat (2) begin          
        #5 Enable = 1'b1;
        #5 Enable = 1'b0;
        #1 $fdisplay(fw,"ReadWrite: %d -- Address: %d -- DataIn: %b -- DataOut: %b -- Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
        Address = Address + 2;
    end   


$finish;
end
endmodule