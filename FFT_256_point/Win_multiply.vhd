library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
package  mul_win is
  function M(a1,b1 : std_logic_vector)
		return std_logic_vector;

end mul_win;

package body mul_win is
function M(a1,b1 : std_logic_vector)
  return std_logic_vector is
  variable temp1: std_logic_vector(31 downto 0) := (others => '0') ;
  variable temp2: std_logic_vector(15 downto 0) := (others => '0') ;
  variable carry: std_logic := '0';
  begin
	  temp1:= a1*b1;
	  if temp1(31)='0' then
        carry := temp1(14) ;
		else
		  carry := temp1(14) and temp1(13);
		end if;
		  
        temp2:= temp1(30 downto 15) + carry;

--temp1:=signed(a1)*signed(b1);
--temp2:=temp1(31)&temp1(21 downto 7);

	  return temp2;
end function M;
end mul_win;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE ieee.numeric_std.ALL;

entity Win_multiply is
	generic (Bi:integer:=16);
		Port(
			clk : in std_logic;
			por : in std_logic;
			x_r : in std_logic_vector(Bi-1 downto 0);
			x_i : in std_logic_vector(Bi-1 downto 0);
			win_co : in std_logic_vector(Bi-1 downto 0);
			wx_r : out std_logic_vector(Bi-1 downto 0);
			wx_i : out std_logic_vector(Bi-1 downto 0)
			);
end Win_multiply;
use work.mul_win.all;
architecture Behavioral of Win_multiply is
		begin
		process(por,clk)
			begin
			if(por ='1') then
				--x_r<=(others=>'0');
				--x_i<=(others=>'0');
				wx_r<=(others=>'0');
				wx_i<=(others=>'0');
			elsif (rising_edge(clk)) then
				wx_r<=M(x_r,win_co);
				wx_i<=x_i;
			end if;	
			
		end process;
end Behavioral;	