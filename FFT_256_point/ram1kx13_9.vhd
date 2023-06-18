library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_9 is 
    port( data9_r : in std_logic_vector(15 downto 0);
	   Q9_r : out std_logic_vector(15 downto 0);
      WAddress_5 : in  std_logic_vector(2 downto 0); 
      RAddress_5 : in  std_logic_vector(2 downto 0);
      WE_5, RE_5 ,WClock,RClock  : in std_logic;
		data9_i : in std_logic_vector(15 downto 0);
	   Q9_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_9 ;


architecture DEF_ARCH of  ram1kx13_9  is

type MEM is array (0 to 7) of std_logic_vector(15 downto 0);
signal ramTmp_9_r : MEM;
signal ramTmp_9_i : MEM;



begin
process (WClock)
begin
		if (falling_edge(WClock)) then
				if (WE_5 = '0' ) then
						ramTmp_9_r (conv_integer (WAddress_5)) <= Data9_r;
                  ramTmp_9_i (conv_integer (WAddress_5)) <= Data9_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_5 = '1' ) then
						Q9_r <= ramTmp_9_r (conv_integer(RAddress_5));
                  Q9_i <= ramTmp_9_i (conv_integer(RAddress_5));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

