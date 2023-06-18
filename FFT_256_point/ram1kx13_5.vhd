library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_5 is 
    port( data5_r : in std_logic_vector(15 downto 0);
	   Q5_r : out std_logic_vector(15 downto 0);
      WAddress_3 : in  std_logic_vector(4 downto 0); 
      RAddress_3 : in  std_logic_vector(4 downto 0);
      WE_3, RE_3 ,WClock,RClock  : in std_logic;
		data5_i : in std_logic_vector(15 downto 0);
	   Q5_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_5 ;


architecture DEF_ARCH of  ram1kx13_5  is

type MEM is array (0 to 31) of std_logic_vector(15 downto 0);
signal ramTmp_5_r : MEM;
signal ramTmp_5_i : MEM;



begin
process (WClock)
begin
		if (falling_edge(WClock)) then
				if (WE_3 = '0' ) then
						ramTmp_5_r (conv_integer (WAddress_3)) <= Data5_r;
                  ramTmp_5_i (conv_integer (WAddress_3)) <= Data5_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_3 = '1' ) then
						Q5_r <= ramTmp_5_r (conv_integer(RAddress_3));
                  Q5_i <= ramTmp_5_i (conv_integer(RAddress_3));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

