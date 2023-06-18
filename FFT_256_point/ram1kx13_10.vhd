library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_10 is 
    port( data10_r : in std_logic_vector(15 downto 0);
	   Q10_r : out std_logic_vector(15 downto 0);
      WAddress_5 : in  std_logic_vector(2 downto 0); 
      RAddress_5 : in  std_logic_vector(2 downto 0);
      WE_5, RE_5 ,WClock,RClock  : in std_logic;
		data10_i : in std_logic_vector(15 downto 0);
	   Q10_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_10 ;


architecture DEF_ARCH of  ram1kx13_10  is

type MEM is array (0 to 7) of std_logic_vector(15 downto 0);
signal ramTmp_10_r : MEM;
signal ramTmp_10_i : MEM;



begin
process (WClock)
begin
		if (rising_edge(WClock)) then
				if (WE_5 = '1' ) then
						ramTmp_10_r (conv_integer (WAddress_5)) <= Data10_r;
                  ramTmp_10_i (conv_integer (WAddress_5)) <= Data10_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_5 = '0' ) then
						Q10_r <= ramTmp_10_r (conv_integer(RAddress_5));
                  Q10_i <= ramTmp_10_i (conv_integer(RAddress_5));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

