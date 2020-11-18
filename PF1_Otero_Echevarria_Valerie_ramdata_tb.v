`include "PF1_Otero_Echevarria_Valerie_ram.v"
module ramdata_tb;

integer file, fw, code, i; reg [31:0] data;
reg clk, ReadWrite; reg[31:0]DataIn;
reg [31:0] Address; wire [31:0] DataOut; reg[1:0]Size;
data_ram256x8 ram1 (DataOut, ReadWrite, Address, DataIn, Size);

//Pre-charge memory
initial begin
    file = $fopen("PF1_Otero_Echevarria_Valerie_ramdata.txt","rb");
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
    clk = 1'b0; 
    ReadWrite = 1'b0; //Read  
    Size = 2'b10; //WORD

    repeat (17) begin
    #1 clk = 1'b1;
    #1 clk = 1'b0;
    Address = Address + 4;    
    end
    $finish;
    end 

    always @ (posedge clk)
        begin
        #1;   
        $fdisplay(fw,"Data en %d = %b %d", Address, DataOut, $time);
    end

/*
    $fdisplay(fw, "-------------- Reading Word from Addresses 0, 4, 8 and 12 ----------------\n");   
    Size = 2'b10; //WORD
    ReadWrite = 1'b0; //Read
    repeat (4) begin          
        #5 clk = 1'b1;
        #5 clk = 1'b0;
        #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
        Address = Address + 4;
    end 


    $fdisplay(fw, "\n\n-------------- Reading Byte from Address 0; Half-Word from Addresses 2 and 4 ----------------\n");   
    Size = 2'b00; //BYTE
    ReadWrite = 1'b0; //Read
    Address = 0;
    repeat (3) begin          
        #5 clk = 1'b1;
        #5 clk = 1'b0;
        #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
        Address = Address + 2;
        Size = 2'b01; //Switched to HALF-WORD
    end  


    $fdisplay(fw, "\n\n-------------- Writing Byte to Address 0; Half-Word to Addresses 2 and 4; Word to Address 8 ----------------\n");  
    Size = 2'b00; //Byte
    ReadWrite = 1'b1; //Write
    DataIn = 8'b10110101;
    Address = 0;
    #5 clk = 1'b1;
    #5 clk = 1'b0;
    #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
    Address = Address + 2;  
              
    Size = 2'b01; //HALF-WORD
    ReadWrite = 1'b1; //Write
    DataIn = 16'b1111111111010011;    
    repeat (2) begin          
        #5 clk = 1'b1;
        #5 clk = 1'b0;
        #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
        Address = Address + 2;               
    end   
     
    Size = 2'b10; //WORD
    ReadWrite = 1'b1; //Write
    DataIn = 32'b11100011010111011000101011000101;
    Address = 8;
    #5 clk = 1'b1;
    #5 clk = 1'b0;
    #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);


    $fdisplay(fw, "\n\n-------------- Reading Word from Addresses 4 and 8 ----------------\n");   
    Size = 2'b10; //WORD
    ReadWrite = 1'b0; //Read
    Address = 0;
    repeat (2) begin          
        #5 clk = 1'b1;
        #5 clk = 1'b0;
        #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
        Address = Address + 4;
    end */

//$finish; 
//end
endmodule