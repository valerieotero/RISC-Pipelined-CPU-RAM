//Data Out - Bus that provides data on a read operation
//Data In – Bus that receives data to be stored on write operation
//Address – Bus for specifying memory address
//R/W– Read/Write operation (0- read, 1 write)

/*
------------------------------------ MEMORY MODULOS -------------------------------------  
*/ 

//INSTRUCTION MEMORY 
module inst_ram256x8(output reg[31:0] DataOut, input Enable, input [31:0]Address);
                  
   reg[7:0] Mem[0:255]; //256 localizaciones 
   
    always @ (Enable)
        if (Enable) //When Enable = 1            
            if(Address%4==0) //Instructions have to start at even locations that are multiples of 4.
            begin    
                DataOut = {Mem[Address+0], Mem[Address+1], Mem[Address+2], Mem[Address+3]};                
            end
            else
                DataOut= Mem[Address];   
endmodule                              
              

//DATA MEMORY
module data_ram256x8(output reg[31:0] DataOut, input Enable, ReadWrite, input[31:0] Address, input[31:0] DataIn, input [1:0] Size);

    reg[7:0] Mem[0:255]; //256 localizaciones 

    always @ (Enable, ReadWrite)
        if (Enable) //When Enable = 1        
        begin

            casez(Size) //"casez" to ignore dont care values
            2'b00: //BYTE
            begin 
                if (ReadWrite) //When Write 
                begin
                    Mem[Address] = DataIn; 
                end
                else //When Read
                begin
                    DataOut= Mem[Address];
                end                
            end

              2'b01: //HALF-WORD
            begin
                if (ReadWrite) //When Write 
                begin
                    Mem[Address] = DataIn[15:8]; 
                    Mem[Address + 1] = DataIn[7:0]; 
                end
                else //When Read
                begin
                     DataOut = {Mem[Address+0], Mem[Address+1]}; 
                end  
            end

            2'b10: //WORD
            begin
                if (ReadWrite) //When Write 
                begin
                    Mem[Address] = DataIn[31:24];
                    Mem[Address + 1] = DataIn[23:16];
                    Mem[Address + 2] = DataIn[15:8]; 
                    Mem[Address + 3] = DataIn[7:0]; 
                end                 
                else //When Read
                begin
                     DataOut = {Mem[Address + 0], Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]}; 
                end  
            end
          
            endcase
            
        end
endmodule


/*
------------------------------------ TEST MODULOS -------------------------------------  
*/

//INSTRUCTION MEMORY - TEST 
//`include "mem.v"
module instmem_tb;

integer file, fw, code, i; reg [31:0] data;
reg Enable;
reg [31:0] Address; wire [31:0] DataOut;

inst_ram256x8 ram1 (DataOut, Enable, Address );

initial
    begin
    file = $fopen("inst_input_file.txt","rb");
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
    repeat (16) begin
    #5 Enable = 1'b1;
    #5 Enable = 1'b0;
    Address = Address + 1;
end
$finish;
end
always @ (posedge Enable)
    begin
    #1;   
    $fdisplay(fw,"Data en %d = %h %d", Address, DataOut, $time);
end
endmodule

//DATA MEMORY - TEST 
//`include "mem.v"
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
        #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
        Address = Address + 4;
    end 


    $fdisplay(fw, "\n\n-------------- Reading Byte from Address 0; Half-Word from Addresses 2 and 4 ----------------\n");   
    Size = 2'b00; //BYTE
    ReadWrite = 1'b0; //Read
    Address = 0;
    repeat (3) begin          
        #5 Enable = 1'b1;
        #5 Enable = 1'b0;
        #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
        Address = Address + 2;
        Size = 2'b01; //Switched to HALF-WORD
    end  


    $fdisplay(fw, "\n\n-------------- Writing Byte to Address 0; Half-Word to Addresses 2 and 4; Word to Address 8 ----------------\n");  
    Size = 2'b00; //Byte
    ReadWrite = 1'b1; //Write
    DataIn = 8'b10110101;
    Address = 0;
    #5 Enable = 1'b1;
    #5 Enable = 1'b0;
    #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
    Address = Address + 2;  
              
    Size = 2'b01; //HALF-WORD
    ReadWrite = 1'b1; //Write
    DataIn = 16'b1111111111010011;    
    repeat (2) begin          
        #5 Enable = 1'b1;
        #5 Enable = 1'b0;
        #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
        Address = Address + 2;               
    end   
     
    Size = 2'b10; //WORD
    ReadWrite = 1'b1; //Write
    DataIn = 32'b11100011010111011000101011000101;
    Address = 8;
    #5 Enable = 1'b1;
    #5 Enable = 1'b0;
    #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);


    $fdisplay(fw, "\n\n-------------- Reading Word from Addresses 4 and 8 ----------------\n");   
    Size = 2'b10; //WORD
    ReadWrite = 1'b0; //Read
    Address = 4;
    repeat (2) begin          
        #5 Enable = 1'b1;
        #5 Enable = 1'b0;
        #1 $fdisplay(fw,"ReadWrite: %d | Address: %d | DataIn: %b | DataOut: %b | Time: %d",ReadWrite, Address, DataIn, DataOut, $time);
        Address = Address + 4;
    end 

$finish;
end
endmodule