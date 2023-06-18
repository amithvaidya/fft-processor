library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_11 is 
    port( data11_r : in std_logic_vector(15 downto 0);
	   Q11_r : out std_logic_vector(15 downto 0);
      WAddress_6 : in  std_logic_vector(1 downto 0); 
      RAddress_6 : in  std_logic_vector(1 downto 0);
      WE_6, RE_6 ,WClock,RClock  : in std_logic;
		data11_i : in std_logic_vector(15 downto 0);
	   Q11_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_11 ;


architecture DEF_ARCH of  ram1kx13_11  is

type MEM is array (0 to 3) of std_logic_vector(15 downto 0);
signal ramTmp_11_r : MEM;
signal ramTmp_11_i : MEM;



begin
process (WClock)
begin
		if (falling_edge(WClock)) then
				if (WE_6 = '0' ) then
						ramTmp_11_r (conv_integer (WAddress_6)) <= Data11_r;
                  ramTmp_11_i (conv_integer (WAddress_6)) <= Data11_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_6 = '1' ) then
						Q11_r <= ramTmp_11_r (conv_integer(RAddress_6));
                  Q11_i <= ramTmp_11_i (conv_integer(RAddress_6));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

