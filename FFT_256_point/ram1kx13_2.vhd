library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_2 is 
    port( data2_r : in std_logic_vector(15 downto 0);
	   Q2_r : out std_logic_vector(15 downto 0);
      WAddress_1 : in  std_logic_vector(6 downto 0); 
      RAddress_1 : in  std_logic_vector(6 downto 0);
      WE_1, RE_1 ,WClock,RClock  : in std_logic;
		data2_i : in std_logic_vector(15 downto 0);
	   Q2_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_2 ;


architecture DEF_ARCH of  ram1kx13_2  is

type MEM is array (0 to 127) of std_logic_vector(15 downto 0);
signal ramTmp_2_r : MEM;
signal ramTmp_2_i : MEM;



begin
process (WClock)
begin
		if (rising_edge(WClock)) then
				if (WE_1 = '1' ) then
						ramTmp_2_r (conv_integer (WAddress_1)) <= Data2_r;
                  ramTmp_2_i (conv_integer (WAddress_1)) <= Data2_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_1 = '0' ) then
						Q2_r <= ramTmp_2_r (conv_integer(RAddress_1));
                  Q2_i <= ramTmp_2_i (conv_integer(RAddress_1));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

