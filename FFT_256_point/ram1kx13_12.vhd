library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_12 is 
    port( data12_r : in std_logic_vector(15 downto 0);
	   Q12_r : out std_logic_vector(15 downto 0);
      WAddress_6 : in  std_logic_vector(1 downto 0); 
      RAddress_6 : in  std_logic_vector(1 downto 0);
      WE_6, RE_6 ,WClock,RClock  : in std_logic;
		data12_i : in std_logic_vector(15 downto 0);
	   Q12_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_12;


architecture DEF_ARCH of  ram1kx13_12  is

type MEM is array (0 to 3) of std_logic_vector(15 downto 0);
signal ramTmp_12_r : MEM;
signal ramTmp_12_i : MEM;



begin
process (WClock)
begin
		if (rising_edge(WClock)) then
				if (WE_6 = '1' ) then
						ramTmp_12_r (conv_integer (WAddress_6)) <= Data12_r;
                  ramTmp_12_i (conv_integer (WAddress_6)) <= Data12_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_6 = '0' ) then
						Q12_r <= ramTmp_12_r (conv_integer(RAddress_6));
                  Q12_i <= ramTmp_12_i (conv_integer(RAddress_6));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

