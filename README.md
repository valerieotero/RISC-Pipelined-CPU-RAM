# RISC-Pipelined-Microprocessor
Computer Architecture and Organization class project (ICOM4215) - Fall 2020

* To run/test the instruction RAM, on a terminal write the following:

$ iverilog -o inst_mem_tb.vvp PF1_Otero_Echevarria_Valerie_ramintr_tb.v

$ vvp inst_mem_tb.vvp

After the second command, whatever input is on the "inst_input_file", the "inst_memcontent" file will show the output


--------------------------------------------------------------------------------------------------------------------------------------


* To run/test the data RAM, on a terminal write the following:

$ iverilog -o data_mem_tb.vvp PF1_Otero_Echevarria_Valerie_ramdata_tb.v

$ vvp data_mem_tb.vvp

After the second command, whatever input is on the "data_input_file", the "data_memcontent" file will show the output
