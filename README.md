# Verilog_testbench_memory_module
Verilog testbench for a memory module
Uses a structure to encapsulate each read/ write transaction.  Creates an array or queue of structures that contains 6 transactions (i.e. structures) that the self-checking testbench will apply to the DUT. The elements of the structure will be:
    1. Address to read/write
    2. Data to write
    3. Expected data read
    4. Actual data read

The address and data will continue to be randomly generated. After applying the 6 writes shuffle the array or queue to apply the reads in a different order. Again print out the data that was read at the end of the test. The structure and array or queue for the structure are the only methods needed to store data. 
