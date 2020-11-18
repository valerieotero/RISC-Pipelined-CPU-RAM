//Data Out - Bus that provides data on a read operation
//Data In – Bus that receives data to be stored on write operation
//Address – Bus for specifying memory address
//R/W– Read/Write operation (0- read, 1 write)


//INSTRUCTION MEMORY 
module inst_ram256x8(output reg[31:0] DataOut, input [31:0]Address, input Reset);
                  
   reg[7:0] Mem[0:255]; //256 localizaciones 
   
    always @ (DataOut,Address,Reset)  
    begin

        if (Reset)            
            DataOut = 32'b00000000000000000000000000000000;            
             
        else //Not Reset
        begin

            if(Address%4==0) //Instructions have to start at even locations that are multiples of 4.                        
                DataOut = {Mem[Address+0], Mem[Address+1], Mem[Address+2], Mem[Address+3]};                
                
            else                    
                DataOut= Mem[Address]; 
                     
        end        
    end 
endmodule                             
              

//DATA MEMORY
module data_ram256x8(output reg[31:0] DataOut, input ReadWrite, input[31:0] Address, input[31:0] DataIn, input [1:0] Size);

    reg[7:0] Mem[0:255]; //256 localizaciones 

    always @ (DataOut, ReadWrite, Address, DataIn, Size)       

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
endmodule