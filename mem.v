//Data Out - Bus that provides data on a read operation
//Data In – Bus that receives data to be stored on write operation
//Address – Bus for specifying memory address
//R/W– Read/Write operation (0- read, 1 write)

//INSTRUCTION MEMORY 
module inst_ram256x8(output reg[31:0] DataOut, input Enable, input [31:0]Address);
                  
   reg[7:0] Mem[0:255]; //256 localizaciones 
   
    always @ (Enable)
        if (Enable) //When Enable = 1            
            if(Address==0 || Address%4==0) 
            begin    
                DataOut = {Mem[Address+0], Mem[Address+1], Mem[Address+2], Mem[Address+3]};                
            end
            else
                DataOut= Mem[Address];   
endmodule                              
              

//DATA MEMORY
module data_ram256x8(output reg[31:0] DataOut, input Enable, ReadWrite, input[31:0] Address, input[31:0] DataIn);

    reg[31:0] Mem[0:255]; //256 localizaciones de 32-bits

    always @ (Enable, ReadWrite)
        if (Enable) //When Enable = 1
            if (ReadWrite) Mem[Address] = DataIn; //When ReadWrite = 1
            else Mem[Address] = DataIn;

endmodule