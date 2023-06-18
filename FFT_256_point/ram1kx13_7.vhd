library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_7 is 
    port( data7_r : in std_logic_vector(15 downto 0);
	   Q7_r : out std_logic_vector(15 downto 0);
      WAddress_4 : in  std_logic_vector(3 downto 0); 
      RAddress_4 : in  std_logic_vector(3 downto 0);
      WE_4, RE_4 ,WClock,RClock  : in std_logic;
		data7_i : in std_logic_vector(15 downto 0);
	   Q7_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_7 ;


architecture DEF_ARCH of  ram1kx13_7  is

type MEM is array (0 to 15) of std_logic_vector(15 downto 0);
signal ramTmp_7_r : MEM;
signal ramTmp_7_i : MEM;



begin
process (WClock)
begin
		if (falling_edge(WClock)) then
				if (WE_4 = '0' ) then
						ramTmp_7_r (conv_integer (WAddress_4)) <= Data7_r;
                  ramTmp_7_i (conv_integer (WAddress_4)) <= Data7_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_4 = '1' ) then
						Q7_r <= ramTmp_7_r (conv_integer(RAddress_4));
                  Q7_i <= ramTmp_7_i (conv_integer(RAddress_4));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

