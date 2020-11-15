/***********************************************************************
 * This file contains the UART Transmitter (TX)
 * The RX can transmit 8 bits of serial data
 * The TX has one start bit, one stop bit and no parity bit
***********************************************************************/
 
module UART_TX 
  #(parameter CLOCKS_PER_BIT = 217)
  (
   input logic      clk,
   input logic      i_TX_Data_Valid,
   input logic [7:0] i_TX_Byte, 
   output logic     o_TX_Active,
   output logic  o_TX_Serial,
   output logic     o_TX_Done
   );

  enum bit [2:0] { IDLE = 3'b000,
                   TX_START_BIT = 3'b001,
		           TX_DATA_BITS = 3'b010,
	               TX_STOP_BIT = 3'b011,
		           CLEANUP = 3'b100 } state;
  
  logic [7:0] reg_Clock_Count = 0;
  logic [2:0] reg_Bit_Index   = 0;
  logic [7:0] reg_TX_Data     = 0;
  logic       reg_TX_Done     = 0;
  logic       reg_TX_Active   = 0;
    
  always @(posedge clk)
  begin
    case (state)
          IDLE :
        begin
          o_TX_Serial   <= 1'b1;         
          reg_TX_Done     <= 1'b0;
          reg_Clock_Count <= 0;
          reg_Bit_Index   <= 0;
          
          if (i_TX_Data_Valid == 1'b1)
          begin
            reg_TX_Active <= 1'b1;
            reg_TX_Data   <= i_TX_Byte;
            state   <=     TX_START_BIT;
          end
          else
            state <= IDLE;
        end // case: IDLE
      
      

      TX_START_BIT :
        begin
          o_TX_Serial <= 1'b0;

          if (reg_Clock_Count < CLOCKS_PER_BIT-1)
          begin
            reg_Clock_Count <= reg_Clock_Count + 1;
            state         <= TX_START_BIT;
          end
          else
          begin
            reg_Clock_Count <= 0;
            state         <= TX_DATA_BITS;
          end
        end // case: TX_START_BIT
      
      
     
      TX_DATA_BITS :
        begin
          o_TX_Serial <= reg_TX_Data[reg_Bit_Index];
          
          if (reg_Clock_Count < CLOCKS_PER_BIT-1)
          begin
            reg_Clock_Count <= reg_Clock_Count + 1;
            state         <= TX_DATA_BITS;
          end
          else
          begin
            reg_Clock_Count <= 0;

            if (reg_Bit_Index < 7)
            begin
              reg_Bit_Index <= reg_Bit_Index + 1;
              state   <=     TX_DATA_BITS;
            end
            else
            begin
              reg_Bit_Index <= 0;
              state   <=     TX_STOP_BIT;
            end
          end 
        end // case: TX_DATA_BITS
      
      TX_STOP_BIT :
        begin
          o_TX_Serial <= 1'b1;
          
          if (reg_Clock_Count < CLOCKS_PER_BIT-1)
          begin
            reg_Clock_Count <= reg_Clock_Count + 1;
            state         <= TX_STOP_BIT;
          end
          else
          begin
            reg_TX_Done     <= 1'b1;
            reg_Clock_Count <= 0;
            state         <= CLEANUP;
            reg_TX_Active   <= 1'b0;
          end 
        end // case: TX_STOP_BIT
      
      CLEANUP :
        begin
          reg_TX_Done <= 1'b1;
          state <= IDLE;
        end
      default :
      begin
        state <= IDLE;
      end
      
    endcase
  end
  
  assign o_TX_Active = reg_TX_Active;
  assign o_TX_Done   = reg_TX_Done;
  
endmodule
