library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_8 is 
    port( data8_r : in std_logic_vector(15 downto 0);
	   Q8_r : out std_logic_vector(15 downto 0);
      WAddress_4 : in  std_logic_vector(3 downto 0); 
      RAddress_4 : in  std_logic_vector(3 downto 0);
      WE_4, RE_4 ,WClock,RClock  : in std_logic;
		data8_i : in std_logic_vector(15 downto 0);
	   Q8_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_8 ;


architecture DEF_ARCH of  ram1kx13_8  is

type MEM is array (0 to 15) of std_logic_vector(15 downto 0);
signal ramTmp_8_r : MEM;
signal ramTmp_8_i : MEM;



begin
process (WClock)
begin
		if (rising_edge(WClock)) then
				if (WE_4 = '1' ) then
						ramTmp_8_r (conv_integer (WAddress_4)) <= Data8_r;
                  ramTmp_8_i (conv_integer (WAddress_4)) <= Data8_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_4 = '0' ) then
						Q8_r <= ramTmp_8_r (conv_integer(RAddress_4));
                  Q8_i <= ramTmp_8_i (conv_integer(RAddress_4));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

