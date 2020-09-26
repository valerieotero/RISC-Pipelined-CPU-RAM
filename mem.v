//Data Out - Bus that provides data on a read operation
//Data In – Bus that receives data to be stored on write operation
//Address – Bus for specifying memory address
//R/W– Read/Write operation (0- read, 1 write)
module inst_ram256x32(output reg[31:0] DataOut, input Enable, input [31:0]Address);

    reg[31:0] Mem[0:255]; //256 localizaciones de 32-bits
    assign ReadWrite = 1'b0; //Read-only

     always @ (Enable) begin//When Enable = 1
        $display("entered always");
        if(Enable)           
            if (!ReadWrite) DataOut = Mem[Address]; //When ReadWrite = 1
            
     end   

endmodule 




module data_ram256x32(output reg[31:0] DataOut, input Enable, ReadWrite, input[31:0] Address, input[31:0] DataIn);

    reg[31:0] Mem[0:255]; //256 localizaciones de 32-bits

    always @ (Enable, ReadWrite)
        if (Enable) //When Enable = 1
            if (ReadWrite) Mem[Address] = DataIn; //When ReadWrite = 1
            else Mem[Address] = DataIn;

endmodule