//Data Out - Bus that provides data on a read operation
//Data In – Bus that receives data to be stored on write operation
//Address – Bus for specifying memory address
//R/W– Read/Write operation (0- read, 1 write)
module inst_ram256x32(output reg[31:0] DataOut, input Enable, ReadWrite, input [31:0]Address);

    reg[31:0] Mem[0:255]; //256 localizaciones de 32-bits
    assign ReadWrite = 1'b0; //Read-only

     always @ (Enable) //When Enable = 1
        if(Enable)
            if(!ReadWrite) DataOut = Mem[Address]; //

endmodule 




module data_ram256x32(output reg[31:0] DataOut, input Enable, ReadWrite, input[31:0] Address, input[31:0] DataIn);

    reg[31:0] Mem[0:255]; //256 localizaciones de 32-bits

    always @ (Enable, ReadWrite)
        if (Enable)
            if (ReadWrite)  Mem[Address] = DataIn;
            else DataOut = Mem[Address];

endmodule