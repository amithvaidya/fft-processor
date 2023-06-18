library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram1kx13_1 is 
    port( data1_r : in std_logic_vector(15 downto 0);
	   Q1_r : out std_logic_vector(15 downto 0);
      WAddress_1 : in  std_logic_vector(6 downto 0); 
      RAddress_1 : in  std_logic_vector(6 downto 0);
      WE_1, RE_1 ,WClock,RClock  : in std_logic;
		data1_i : in std_logic_vector(15 downto 0);
	   Q1_i : out std_logic_vector(15 downto 0)
		);
end ram1kx13_1 ;


architecture DEF_ARCH of  ram1kx13_1  is

type MEM is array (0 to 127) of std_logic_vector(15 downto 0);
signal ramTmp_1_r : MEM :=(others=>(others=>'0'));
signal ramTmp_1_i : MEM :=(others=>(others=>'0'));


begin
process (WClock)
begin
		if (falling_edge(WClock)) then
				if (WE_1 = '0' ) then
						ramTmp_1_r (conv_integer (WAddress_1)) <= Data1_r;
                  ramTmp_1_i (conv_integer (WAddress_1)) <= Data1_i;						
				end if; 
		end if;  
end process;

process ( RClock)
begin
		if (falling_edge( RClock)) then        
        if (RE_1 = '1' ) then
						Q1_r <= ramTmp_1_r (conv_integer(RAddress_1));
                  Q1_i <= ramTmp_1_i (conv_integer(RAddress_1));						
				end if;
        
		end if;    
end process;

end DEF_ARCH;

