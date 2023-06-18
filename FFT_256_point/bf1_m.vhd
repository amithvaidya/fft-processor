library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE ieee.numeric_std.ALL;
entity bf1_m is
generic(Bi : integer := 16);
Port (     por  : in std_logic;
	        a_r  : in std_logic_vector(Bi - 1 downto 0);
	        a_i  : in std_logic_vector(Bi - 1 downto 0);
           a1_r : in std_logic_vector(Bi - 1 downto 0);
	        a1_i : in std_logic_vector(Bi - 1 downto 0);
			  i2   : in std_logic;
			  i3   : in std_logic;
			  b_r  : out std_logic_vector(Bi - 1  downto 0);
			  b_i  : out std_logic_vector(Bi - 1 downto 0);
			  b1_r : out std_logic_vector(Bi - 1  downto 0);
			  b1_i : out std_logic_vector(Bi - 1  downto 0)
			 );
end bf1_m;
architecture Behavioral of bf1_m is
begin
process(por,i3)
begin
  if(por='1') then
      b_r <=   (others => '0'); 
		b_i <=   (others => '0'); 
		b1_r <=  (others => '0'); 
		b1_i <=  (others => '0'); 
  elsif(i3 = '1') then
		if i2 = '0'  then
			b_r <=   a_r ;
			b_i <=   a_i ;
			b1_r <=  a1_r ;
			b1_i <=  a1_i ;
		else
			b_r  <= ( a1_r) - ( a_r) ;
			b_i  <= ( a1_i) - ( a_i) ;
			b1_r <= ( a1_r) + ( a_r) ;
			b1_i <= ( a1_i) + ( a_i) ;
		end if;
  end if;
end process;
end Behavioral;
