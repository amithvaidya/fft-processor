library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_3 is 
    port( 
		data3_r : in std_logic_vector(15 downto 0);
		Q3_r : out std_logic_vector(15 downto 0);
		WAddress_2 : in  std_logic_vector(5 downto 0); 
      RAddress_2 : in  std_logic_vector(5 downto 0);
      WE_2, RE_2 ,WClock,RClock  : in std_logic;
		data3_i : in std_logic_vector(15 downto 0);
	   Q3_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_3 ;


architecture DEF_ARCH of  ram1kx13_3  is

type MEM is array (0 to 63) of std_logic_vector(15 downto 0);
signal ramTmp_3_r : MEM;
signal ramTmp_3_i : MEM;



begin
process (WClock)
begin
		if (falling_edge(WClock)) then
				if (WE_2 = '0' ) then
						ramTmp_3_r (conv_integer (WAddress_2)) <= Data3_r;
                  ramTmp_3_i (conv_integer (WAddress_2)) <= Data3_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_2 = '1' ) then
						Q3_r <= ramTmp_3_r (conv_integer(RAddress_2));
                  Q3_i <= ramTmp_3_i (conv_integer(RAddress_2));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

