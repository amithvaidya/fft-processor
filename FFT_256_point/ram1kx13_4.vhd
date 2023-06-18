library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_4 is 
    port( data4_r : in std_logic_vector(15 downto 0);
	   Q4_r : out std_logic_vector(15 downto 0);
      WAddress_2 : in  std_logic_vector(5 downto 0); 
      RAddress_2 : in  std_logic_vector(5 downto 0);
      WE_2, RE_2 ,WClock,RClock  : in std_logic;
		data4_i : in std_logic_vector(15 downto 0);
	   Q4_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_4 ;


architecture DEF_ARCH of  ram1kx13_4  is

type MEM is array (0 to 63) of std_logic_vector(15 downto 0);
signal ramTmp_4_r : MEM;
signal ramTmp_4_i : MEM;



begin
process (WClock)
begin
		if (rising_edge(WClock)) then
				if (WE_2 = '1' ) then
						ramTmp_4_r (conv_integer (WAddress_2)) <= Data4_r;
                  ramTmp_4_i (conv_integer (WAddress_2)) <= Data4_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_2 = '0' ) then
						Q4_r <= ramTmp_4_r (conv_integer(RAddress_2));
                  Q4_i <= ramTmp_4_i (conv_integer(RAddress_2));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

