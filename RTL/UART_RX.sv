/***********************************************************************
 * This file contains the UART Receiver (RX)
 * The RX can receive 8 bits of serial data
 * The RX has one start bit, one stop bit and no parity bit
***********************************************************************/
 
module UART_RX
  #(parameter CLOCKS_PER_BIT = 217)
  (
   input  logic  clk,
   input  logic  i_RX_Serial,
   output logic  o_RX_Data_Valid,
   output logic  [7:0] o_RX_Byte
   );
   
  enum bit [2:0] { IDLE = 3'b000,
                   RX_START_BIT = 3'b001,
		               RX_DATA_BITS = 3'b010,
	                 RX_STOP_BIT = 3'b011,
		               CLEANUP = 3'b100 } state;

  logic [7:0] reg_Clock_Count = 0;
  logic [2:0] reg_Bit_Index   = 0; 
  logic [7:0] reg_RX_Byte     = 0;
  logic       reg_RX_DV       = 0;
    
  always @(posedge clk)
  begin
      
    case (state)
      IDLE :
        begin
          reg_RX_DV       <= 1'b0;
          reg_Clock_Count <= 0;
          reg_Bit_Index   <= 0;
          
          if (i_RX_Serial == 1'b0)          
            state <= RX_START_BIT;
          else
            state <= IDLE;
        end

      RX_START_BIT :
        begin
          if (reg_Clock_Count == (CLOCKS_PER_BIT-1)/2)
          begin
            if (i_RX_Serial == 1'b0)
            begin
              reg_Clock_Count <= 0;  // reset counter, found the middle
              state     <= RX_DATA_BITS;
            end
            else
              state <= IDLE;
          end
          else
          begin
            reg_Clock_Count <= reg_Clock_Count + 1;
            state     <= RX_START_BIT;
          end
        end // case: RX_START_BIT
      
      
      RX_DATA_BITS :
        begin
          if (reg_Clock_Count < CLOCKS_PER_BIT-1)
          begin
            reg_Clock_Count <= reg_Clock_Count + 1;
            state     <= RX_DATA_BITS;
          end
          else
          begin
            reg_Clock_Count          <= 0;
            reg_RX_Byte[reg_Bit_Index] <= i_RX_Serial;
            
      
            if (reg_Bit_Index < 7)
            begin
              reg_Bit_Index <= reg_Bit_Index + 1;
              state   <= RX_DATA_BITS;
            end
            else
            begin
              reg_Bit_Index <= 0;
              state   <= RX_STOP_BIT;
            end
          end
        end // case: RX_DATA_BITS
      
    
      RX_STOP_BIT :
        begin
          if (reg_Clock_Count < CLOCKS_PER_BIT-1)
          begin
            reg_Clock_Count <= reg_Clock_Count + 1;
     	    state     <= RX_STOP_BIT;
          end
          else
          begin
       	    reg_RX_DV       <= 1'b1;
            reg_Clock_Count <= 0;
            state     <= CLEANUP;
          end
        end // case: RX_STOP_BIT
      
  
      CLEANUP :
        begin
          state <= IDLE;
          reg_RX_DV   <= 1'b0;
        end
      
      default :
        state <= IDLE;
      
    endcase
  end    
  
  assign o_RX_Data_Valid   = reg_RX_DV;
  assign o_RX_Byte = reg_RX_Byte;
  
endmodule // UART_RX
