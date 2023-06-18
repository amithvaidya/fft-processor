library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
package  mul is
  function M(a1,b1 : std_logic_vector)
		return std_logic_vector;

end mul;

package body mul is
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
end mul;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE ieee.numeric_std.ALL;
entity bf2_m is
generic(Bi : integer := 16);
Port (     por   : in std_logic;
	        a2_r  : in std_logic_vector(Bi - 1 downto 0);
	        a2_i  : in std_logic_vector(Bi - 1 downto 0);
           a21_r : in std_logic_vector(Bi - 1 downto 0);
	        a21_i : in std_logic_vector(Bi - 1 downto 0);
			  i     : in std_logic;
			  i1    : in std_logic;
			  i4    : in std_logic;
			  W_r   : in std_logic_vector(Bi - 1 downto 0);
			  W_i   : in std_logic_vector(Bi - 1 downto 0);
			  b2_r  : out std_logic_vector(Bi-1 downto 0);
			  b2_i  : out std_logic_vector(Bi-1 downto 0);
			  b21_r : out std_logic_vector(Bi-1 downto 0);
			  b21_i : out std_logic_vector(Bi-1 downto 0)
			 );
end bf2_m;

use work.mul.all;
architecture Behavioral of bf2_m is
begin
process(por,i4)
begin
  if(por='1') then
      b2_r <=   (others => '0'); 
		b2_i <=   (others => '0'); 
		b21_r <=  (others => '0'); 
		b21_i <=  (others => '0'); 
  elsif(i4 = '1') then
	if i = '0'  then
		b2_r  <= (a2_r) ;
		b2_i  <= (a2_i) ;
		b21_r <= M(a21_r,W_r) - M(a21_i,W_i) ;
		b21_i <= M(a21_i,W_r) + M(a21_r,W_i) ;
	else
		if i1 = '1'  then
			b2_r <=  (a21_r) - (a2_r) ;
			b2_i <=  (a21_i) - (a2_i) ;
			b21_r <= M(((a21_r) + (a2_r)),W_r) - M(((a21_i) + (a2_i)),W_i);
			b21_i <= M(((a21_i) + (a2_i)),W_r) + M(((a21_r) + (a2_r)),W_i);
		else
			b2_r  <= (a21_r)  - (a2_i) ; 
			b2_i  <= (a21_i)  + (a2_r) ; 
			b21_r <= M(((a21_r)  + (a2_i)),W_r)- M(((a21_i)  - (a2_r)),W_i); 
			b21_i <= M(((a21_i)  - (a2_r)),W_r)+ M(((a21_r)  + (a2_i)),W_i) ; 
		end if;
	end if;
end if;
end process;
end Behavioral;