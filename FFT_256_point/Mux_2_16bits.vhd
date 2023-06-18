library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux_2_16bits is
    Port ( sel : in  STD_LOGIC;
           in1_r : in  STD_LOGIC_VECTOR (15 downto 0);
	   in1_i : in  STD_LOGIC_VECTOR (15 downto 0);
           in2_r : in  STD_LOGIC_VECTOR (15 downto 0);
	   in2_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           mux_out_16bits_r : out  STD_LOGIC_VECTOR (15 downto 0);
			  mux_out_16bits_i : out  STD_LOGIC_VECTOR (15 downto 0));
end Mux_2_16bits;

architecture Behavioral of Mux_2_16bits is

begin

process (sel,in1_r,in1_i,in2_r,in2_i)
begin
     case (sel) is 
     when '1'    =>  mux_out_16bits_r <= in1_r;
	                  mux_out_16bits_i <= in1_i;
     when '0'    =>  mux_out_16bits_r <= in2_r;
	                  mux_out_16bits_i <= in2_i;
	  
     when others =>  mux_out_16bits_r <= (others => '0');
	                  mux_out_16bits_i <= (others => '0');
     end case;
end process;     
     
     


end Behavioral;



