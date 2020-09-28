//Data Out - Bus that provides data on a read operation
//Data In – Bus that receives data to be stored on write operation
//Address – Bus for specifying memory address
//R/W– Read/Write operation (0- read, 1 write)

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
module data_ram256x8(output reg[31:0] DataOut, input Enable, ReadWrite, input[31:0] Address, input[31:0] DataIn);

    reg[7:0] Mem[0:255]; //256 localizaciones 

    always @ (Enable, ReadWrite)
        if (Enable) //When Enable = 1
        begin
            if (ReadWrite) //When ReadWrite = 1
            begin
                Mem[Address] = DataIn; 
            end
            else //When ReadWrite = 0
            begin
                DataOut= Mem[Address];
            end
        end
endmodule