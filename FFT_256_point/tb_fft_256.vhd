-- tb_fft_256.vhd


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity testbench_final is
end testbench_final;

architecture tb of testbench_final is
	component fft_256 is
		
		generic(Bi : integer := 16);
        Port (  
				por : in std_logic;
				clk : in std_logic;
				phase : in std_logic;
				ind1_0:out std_logic_vector(7 downto 0);
				j1_0:out std_logic_vector(8 downto 0);
				
				x_r : in std_logic_vector(Bi-1 downto 0);
				x_i : in std_logic_vector(Bi-1 downto 0);
				
				vib_frequency: out integer range 0 to 255;
				max_mag: out integer range 0 to 65535;
				
				magnitude_spectrum: out std_logic_vector (31 downto 0)
				
				 );
			 
	end component;
	signal por :std_logic;
	signal clk :std_logic:='0';
	signal phase :std_logic;
	signal x_r :std_logic_vector(16-1 downto 0):=x"0000";
	signal x_i :std_logic_vector(16-1 downto 0);
	signal count: integer;		
	signal ind1_0:std_logic_vector(5 downto 0);
	signal j1_0:std_logic_vector(6 downto 0);
	signal vib_frequency: integer range 0 to 255;
	signal max_mag: integer:=0;
	signal magnitude_spectrum: std_logic_vector (31 downto 0);


	begin
		
		
		fft_256_0 : fft_256 port map(
		
				por=>por,
				clk=>clk,
				phase=>phase,
				x_r=>x_r,
				x_i=>x_i,
				vib_frequency=>vib_frequency,
				max_mag=>max_mag,
				magnitude_spectrum=>magnitude_spectrum
				
		);
		
		clk<=not clk after 5 ms;
		por<='0','1' after 3 ms ,'0' after 7 ms;
		phase<='0','1' after 1 ms ,'0' after 2 ms;
		
		--x_r<="000000001","000001000" after 10ms,"000000001" after 20ms,"000000010" after 30ms,"000000011" after 40ms,"000000100" after 50ms,"000000101" after 60ms,"000000110" after 70ms,"000000111" after 80ms,"000000000" after 90ms,"000001000" after 1290ms,"000001001" after 1300ms,"000001010" after 1310ms,"000001011" after 1320ms,"000001100" after 1330ms,"000001101" after 1340ms,"000001110" after 1350ms,"000001111" after 1360ms,"000000001" after 1370ms,"000000000" after 1380ms;
		
		
		
		--x_r<=x"001A" after 80 ms,x"0000" after 90 ms,x"001A" after 2640 ms,x"0000" after 2650 ms,x"001A" after 5200 ms,x"0000" after 5210 ms,x"001A" after 7760 ms,x"0000" after 7770 ms;		
		
		
		 --x_r<=x"00FF" after 10ms, x"FF01"after 650ms, x"00FF" after 1290ms, x"FF01" after 1930ms,x"0000" after 2570ms;
		 --x_r<=x"00FF" after 10 ms, x"FF01"after 330 ms, x"00FF" after 650 ms, x"FF01" after 970 ms,x"00FF" after 1290 ms, x"FF01" after 1610 ms, x"00FF" after 1930 ms, x"FF01" after 2250 ms,x"00FF" after 2570 ms,
			--x"FF01"after 2890 ms, x"00FF" after 3210 ms, x"FF01" after 3530 ms,x"00FF" after 3850 ms, x"FF01" after 4170 ms, x"00FF" after 4490 ms, x"FF01" after 4810 ms,x"0000" after 5130 ms
			--;
		--x_r<=x"00FF" after 10ms, x"FF01" after 1290ms, x"0000" after 2570ms;
		--x_r<=x"FFF1" after 10 ms,x"000F" after 650 ms, x"FFF1" after 1290 ms, x"000F" after 1930 ms,x"FFF1" after 2570 ms,
		--     x"000F" after 3210 ms, x"FFF1" after 3850 ms, x"000F" after 4490 ms,x"FFF1" after 5130 ms,
		--     x"000F" after 5770 ms, x"FFF1" after 6410 ms, x"000F" after 7050 ms,x"0000" after 7690 ms;
			

		x_r<=X"0000" after 10 ms,
			X"0002" after 20 ms,X"0004" after 30 ms,X"0006" after 40 ms,X"0008" after 50 ms,X"0009" after 60 ms,X"000a" after 70 ms,X"000a" after 80 ms,X"000a" after 90 ms,
			X"000a" after 100 ms,X"000a" after 110 ms,X"0009" after 120 ms,X"0008" after 130 ms,X"0006" after 140 ms,X"0004" after 150 ms,X"0002" after 160 ms,X"0000" after 170 ms,
			X"FFFE" after 180 ms,X"FFFD" after 190 ms,X"FFFB" after 200 ms,X"FFF9" after 210 ms,X"FFF8" after 220 ms,X"FFF7" after 230 ms,X"FFF7" after 240 ms,X"FFF7" after 250 ms,
			X"FFF7" after 260 ms,X"FFF7" after 270 ms,X"FFF8" after 280 ms,X"FFFA" after 290 ms,X"FFFB" after 300 ms,X"FFFD" after 310 ms,X"FFFF" after 320 ms,X"0001" after 330 ms,
			X"0003" after 340 ms,X"0005" after 350 ms,X"0006" after 360 ms,X"0008" after 370 ms,X"0009" after 380 ms,X"000A" after 390 ms,X"000A" after 400 ms,X"000A" after 410 ms,
			X"000A" after 420 ms,X"000A" after 430 ms,X"0009" after 440 ms,X"0007" after 450 ms,X"0006" after 460 ms,X"0004" after 470 ms,X"0002" after 480 ms,X"0000" after 490 ms,
			X"FFFE" after 500 ms,X"FFFC" after 510 ms,X"FFFB" after 520 ms,X"FFF9" after 530 ms,X"FFF8" after 540 ms,X"FFF7" after 550 ms,X"FFF7" after 560 ms,X"FFF7" after 570 ms,
			X"FFF7" after 580 ms,X"FFF7" after 590 ms,X"FFF8" after 600 ms,X"FFFA" after 610 ms,X"FFFB" after 620 ms,X"FFFD" after 630 ms,X"FFFF" after 640 ms,X"0001" after 650 ms,
			X"0003" after 660 ms,X"0005" after 670 ms,X"0006" after 680 ms,X"0008" after 690 ms,X"0009" after 700 ms,X"000A" after 710 ms,X"000A" after 720 ms,X"000A" after 730 ms,
			X"000A" after 740 ms,X"000A" after 750 ms,X"0008" after 760 ms,X"0007" after 770 ms,X"0006" after 780 ms,X"0004" after 790 ms,X"0002" after 800 ms,X"0000" after 810 ms,
			X"FFFE" after 820 ms,X"FFFC" after 830 ms,X"FFFA" after 840 ms,X"FFF9" after 850 ms,X"FFF8" after 860 ms,X"FFF7" after 870 ms,X"FFF7" after 880 ms,X"FFF7" after 890 ms,
			X"FFF7" after 900 ms,X"FFF8" after 910 ms,X"FFF9" after 920 ms,X"FFFA" after 930 ms,X"FFFC" after 940 ms,X"FFFD" after 950 ms,X"FFFF" after 960 ms,X"0001" after 970 ms,
			X"0003" after 980 ms,X"0005" after 990 ms,X"0007" after 1000 ms,X"0008" after 1010 ms,X"0009" after 1020 ms,X"000A" after 1030 ms,X"000A" after 1040 ms,X"000A" after 1050 ms,
			X"000A" after 1060 ms,X"0009" after 1070 ms,X"0008" after 1080 ms,X"0007" after 1090 ms,X"0005" after 1100 ms,X"0004" after 1110 ms,X"0002" after 1120 ms,X"0000" after 1130 ms,
			X"FFFE" after 1140 ms,X"FFFC" after 1150 ms,X"FFFA" after 1160 ms,X"FFF9" after 1170 ms,X"FFF8" after 1180 ms,X"FFF7" after 1190 ms,X"FFF7" after 1200 ms,X"FFF7" after 1210 ms,
			X"FFF7" after 1220 ms,X"FFF8" after 1230 ms,X"FFF9" after 1240 ms,X"FFFA" after 1250 ms,X"FFFC" after 1260 ms,X"FFFE" after 1270 ms,X"0000" after 1280 ms,X"0001" after 1290 ms,
			
			X"0003" after 1300 ms,X"0005" after 1310 ms,X"0007" after 1320 ms,X"0008" after 1330 ms,X"0009" after 1340 ms,X"000A" after 1350 ms,X"000A" after 1360 ms,X"000A" after 1370 ms,
			X"000A" after 1380 ms,X"0009" after 1390 ms,X"0008" after 1400 ms,X"0007" after 1410 ms,X"0005" after 1420 ms,X"0003" after 1430 ms,X"0001" after 1440 ms,X"FFFF" after 1450 ms,
			X"FFFD" after 1460 ms,X"FFFC" after 1470 ms,X"FFFA" after 1480 ms,X"FFF9" after 1490 ms,X"FFF8" after 1500 ms,X"FFF7" after 1510 ms,X"FFF7" after 1520 ms,X"FFF7" after 1530 ms,
			X"FFF7" after 1540 ms,X"FFF8" after 1550 ms,X"FFF9" after 1560 ms,X"FFFA" after 1570 ms,X"FFFC" after 1580 ms,X"FFFE" after 1590 ms,X"0000" after 1600 ms,X"0002" after 1610 ms,
			X"0004" after 1620 ms,X"0005" after 1630 ms,X"0007" after 1640 ms,X"0008" after 1650 ms,X"0009" after 1660 ms,X"000A" after 1670 ms,X"000A" after 1680 ms,X"000A" after 1690 ms,
			X"000A" after 1700 ms,X"0009" after 1710 ms,X"0008" after 1720 ms,X"0007" after 1730 ms,X"0005" after 1740 ms,X"0003" after 1750 ms,X"0001" after 1760 ms,X"FFFF" after 1770 ms,
			X"FFFD" after 1780 ms,X"FFFB" after 1790 ms,X"FFFA" after 1800 ms,X"FFF9" after 1810 ms,X"FFF7" after 1820 ms,X"FFF7" after 1830 ms,X"FFF7" after 1840 ms,X"FFF7" after 1850 ms,
			X"FFF7" after 1860 ms,X"FFF8" after 1870 ms,X"FFF9" after 1880 ms,X"FFFB" after 1890 ms,X"FFFC" after 1900 ms,X"FFFE" after 1910 ms,X"0000" after 1920 ms,X"0002" after 1930 ms,
			X"0004" after 1940 ms,X"0006" after 1950 ms,X"0007" after 1960 ms,X"0009" after 1970 ms,X"000A" after 1980 ms,X"000A" after 1990 ms,X"000A" after 2000 ms,X"000A" after 2010 ms,
			X"000A" after 2020 ms,X"0009" after 2030 ms,X"0008" after 2040 ms,X"0006" after 2050 ms,X"0005" after 2060 ms,X"0003" after 2070 ms,X"0001" after 2080 ms,X"FFFF" after 2090 ms,
			X"FFFD" after 2100 ms,X"FFFB" after 2110 ms,X"FFFA" after 2120 ms,X"FFF8" after 2130 ms,X"FFF7" after 2140 ms,X"FFF7" after 2150 ms,X"FFF7" after 2160 ms,X"FFF7" after 2170 ms,
			X"FFF7" after 2180 ms,X"FFF8" after 2190 ms,X"FFF9" after 2200 ms,X"FFFB" after 2210 ms,X"FFFC" after 2220 ms,X"FFFE" after 2230 ms,X"0000" after 2240 ms,X"0002" after 2250 ms,
			X"0004" after 2260 ms,X"0006" after 2270 ms,X"0007" after 2280 ms,X"0009" after 2290 ms,X"000A" after 2300 ms,X"000A" after 2310 ms,X"000A" after 2320 ms,X"000A" after 2330 ms,
			X"000A" after 2340 ms,X"0009" after 2350 ms,X"0008" after 2360 ms,X"0006" after 2370 ms,X"0004" after 2380 ms,X"0003" after 2390 ms,X"0001" after 2400 ms,X"FFFF" after 2410 ms,
			X"FFFD" after 2420 ms,X"FFFB" after 2430 ms,X"FFF9" after 2440 ms,X"FFF8" after 2450 ms,X"FFF7" after 2460 ms,X"FFF7" after 2470 ms,X"FFF7" after 2480 ms,X"FFF7" after 2490 ms,
			X"FFF7" after 2500 ms,X"FFF8" after 2510 ms,X"FFF9" after 2520 ms,X"FFFB" after 2530 ms,X"FFFD" after 2540 ms,X"FFFF" after 2550 ms,X"0000" after 2560 ms;
	
			x_i<=x"0000";
end;
	