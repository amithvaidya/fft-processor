library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
entity fft_256 is
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
				
				magnitude_spectrum: out std_logic_vector(31 downto 0)
				
				 );
end fft_256;

architecture Behavioral of fft_256 is
	
	Component Win_multiply is
		generic(Bi:integer:=16);
		Port(
			clk : in std_logic;
			por : in std_logic;
			x_r : in std_logic_vector(Bi-1 downto 0);
			x_i : in std_logic_vector(Bi-1 downto 0);
			win_co : in std_logic_vector(Bi-1 downto 0);
			wx_r : out std_logic_vector(Bi-1 downto 0);
			wx_i : out std_logic_vector(Bi-1 downto 0)
			);
	end Component;

	------------Stage 1------------------------
	COMPONENT ram1kx13_1 is 
		port( 	data1_r : in std_logic_vector(15 downto 0);
				Q1_r : out std_logic_vector(15 downto 0);
				WAddress_1 : in  std_logic_vector(6 downto 0); 
				RAddress_1 : in  std_logic_vector(6 downto 0);
				WE_1, RE_1 ,WClock,RClock  : in std_logic;
				data1_i : in std_logic_vector(15 downto 0);
				Q1_i : out std_logic_vector(15 downto 0)
		
			);
	end COMPONENT ;
	COMPONENT ram1kx13_2 is 
		port( 	data2_r : in std_logic_vector(15 downto 0);
				Q2_r : out std_logic_vector(15 downto 0);
				WAddress_1 : in  std_logic_vector(6 downto 0); 
				RAddress_1 : in  std_logic_vector(6 downto 0);
				WE_1, RE_1 ,WClock,RClock  : in std_logic;
				data2_i : in std_logic_vector(15 downto 0);
				Q2_i : out std_logic_vector(15 downto 0)
			);
	end COMPONENT ;
	
	COMPONENT bf1_m is
		port ( 	por  : in std_logic;
				a_r  : in std_logic_vector(Bi - 1 downto 0);
				a_i  : in std_logic_vector(Bi - 1 downto 0);
				a1_r : in std_logic_vector(Bi - 1 downto 0);
				a1_i : in std_logic_vector(Bi - 1 downto 0);
				i2   : in std_logic;
				i3   : in std_logic;
				b_r  : out std_logic_vector(Bi-1  downto 0);
				b_i  : out std_logic_vector(Bi-1  downto 0);
				b1_r : out std_logic_vector(Bi-1  downto 0);
				b1_i : out std_logic_vector(Bi-1  downto 0)
			  );
	end COMPONENT ;

	component Mux_2_16bits is
		Port ( 	sel : in  STD_LOGIC;
				in1_r : in  STD_LOGIC_VECTOR (15 downto 0);
				in1_i : in  STD_LOGIC_VECTOR (15 downto 0);
				in2_r : in  STD_LOGIC_VECTOR (15 downto 0);
				in2_i : in  STD_LOGIC_VECTOR (15 downto 0);
				mux_out_16bits_r : out  STD_LOGIC_VECTOR (15 downto 0);
				mux_out_16bits_i : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	
	---------------Stage 2---------------------------------------
	COMPONENT ram1kx13_3 is 
		port( 	
				data3_r : in std_logic_vector(15 downto 0);
				Q3_r : out std_logic_vector(15 downto 0);
				WAddress_2 : in  std_logic_vector(5 downto 0); 
				RAddress_2 : in  std_logic_vector(5 downto 0);
				WE_2, RE_2 ,WClock,RClock  : in std_logic;
				data3_i : in std_logic_vector(15 downto 0);
				Q3_i: out std_logic_vector(15 downto 0)
				);
	end COMPONENT ;

	COMPONENT ram1kx13_4 is 
		port( 	data4_r : in std_logic_vector(15 downto 0);
				Q4_r : out std_logic_vector(15 downto 0);
				WAddress_2 : in  std_logic_vector(5 downto 0); 
				RAddress_2 : in  std_logic_vector(5 downto 0);
				WE_2, RE_2 ,WClock,RClock  : in std_logic;
				data4_i : in std_logic_vector(15 downto 0);
				Q4_i: out std_logic_vector(15 downto 0)
			);
	end COMPONENT ;

	component Mux_2_16bits_bf2 is
		Port ( 	sel : in  STD_LOGIC;
				in1_r : in  STD_LOGIC_VECTOR (15 downto 0);
				in1_i : in  STD_LOGIC_VECTOR (15 downto 0);
				in2_r : in  STD_LOGIC_VECTOR (15 downto 0);
				in2_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  
				mux_out_16bits_r : out  STD_LOGIC_VECTOR (15 downto 0);
				mux_out_16bits_i : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;

	COMPONENT bf2_m is
		Port ( 	por   : in std_logic;
				a2_r  : in std_logic_vector(Bi - 1 downto 0);
				a2_i  : in std_logic_vector(Bi - 1 downto 0);
				a21_r : in std_logic_vector(Bi - 1 downto 0);
				a21_i : in std_logic_vector(Bi - 1 downto 0);
				i     : in std_logic;
				i1    : in std_logic;
				i4    : in std_logic;
				W_r   : in std_logic_vector(Bi - 1 downto 0);
				W_i   : in std_logic_vector(Bi - 1 downto 0);
				b2_r  : out std_logic_vector(Bi-1 downto 0);
				b2_i  : out std_logic_vector(Bi-1 downto 0);
				b21_r : out std_logic_vector(Bi-1 downto 0);
				b21_i : out std_logic_vector(Bi-1 downto 0)
			 ); 
	end COMPONENT ;
	
	
	-------------Stage 3-------------------------------
	COMPONENT ram1kx13_5 is 
		port( 	data5_r : in std_logic_vector(15 downto 0);
				Q5_r : out std_logic_vector(15 downto 0);
				WAddress_3 : in  std_logic_vector(4 downto 0); 
				RAddress_3 : in  std_logic_vector(4 downto 0);
				WE_3, RE_3 ,WClock,RClock  : in std_logic;
				data5_i : in std_logic_vector(15 downto 0);
				Q5_i: out std_logic_vector(15 downto 0)
				);
	end COMPONENT ;

	COMPONENT ram1kx13_6 is 
		port( 	data6_r : in std_logic_vector(15 downto 0);
				Q6_r : out std_logic_vector(15 downto 0);
				WAddress_3 : in  std_logic_vector(4 downto 0); 
				RAddress_3 : in  std_logic_vector(4 downto 0);
				WE_3, RE_3 ,WClock,RClock  : in std_logic;
				data6_i : in std_logic_vector(15 downto 0);
				Q6_i: out std_logic_vector(15 downto 0)
		  );
	end COMPONENT ;

	COMPONENT bf1_m_15 is
		Port ( 	por  : in std_logic;
				a_r  : in std_logic_vector(Bi - 1 downto 0);
				a_i  : in std_logic_vector(Bi - 1 downto 0);
				a1_r : in std_logic_vector(Bi - 1 downto 0);
				a1_i : in std_logic_vector(Bi - 1 downto 0);
				i2   : in std_logic;
				i3   : in std_logic;
				b_r  : out std_logic_vector(Bi-1  downto 0);
				b_i  : out std_logic_vector(Bi-1  downto 0);
				b1_r : out std_logic_vector(Bi-1  downto 0);
				b1_i : out std_logic_vector(Bi-1  downto 0)
				 );
	end COMPONENT;

	component Mux_2_16bits_bf3 is
		Port ( 	sel : in  STD_LOGIC;
				in1_r : in  STD_LOGIC_VECTOR (15 downto 0);
				in1_i : in  STD_LOGIC_VECTOR (15 downto 0);
				in2_r : in  STD_LOGIC_VECTOR (15 downto 0);
				in2_i : in  STD_LOGIC_VECTOR (15 downto 0);
				  
				mux_out_16bits_r : out  STD_LOGIC_VECTOR (15 downto 0);
				mux_out_16bits_i : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	
	---------------------Stage 4-----------------
	COMPONENT ram1kx13_7 is 
		port( 	data7_r : in std_logic_vector(15 downto 0);
				Q7_r : out std_logic_vector(15 downto 0);
				WAddress_4 : in  std_logic_vector(3 downto 0); 
				RAddress_4 : in  std_logic_vector(3 downto 0);
				WE_4, RE_4 ,WClock,RClock  : in std_logic;
				data7_i : in std_logic_vector(15 downto 0);
				Q7_i: out std_logic_vector(15 downto 0)
			);
	end COMPONENT ;

	COMPONENT ram1kx13_8 is 
		port( 	data8_r : in std_logic_vector(15 downto 0);
				Q8_r : out std_logic_vector(15 downto 0);
				WAddress_4 : in  std_logic_vector(3 downto 0); 
				RAddress_4 : in  std_logic_vector(3 downto 0);
				WE_4, RE_4 ,WClock,RClock  : in std_logic;
				data8_i : in std_logic_vector(15 downto 0);
				Q8_i: out std_logic_vector(15 downto 0)
		  );
	end COMPONENT ;

	component Mux_2_16bits_bf4 is
		Port ( 	sel : in  STD_LOGIC;
				in1_r : in  STD_LOGIC_VECTOR (15 downto 0);
				in1_i : in  STD_LOGIC_VECTOR (15 downto 0);
				in2_r : in  STD_LOGIC_VECTOR (15 downto 0);
				in2_i : in  STD_LOGIC_VECTOR (15 downto 0);
				  
			    mux_out_16bits_r : out  STD_LOGIC_VECTOR (15 downto 0);
				mux_out_16bits_i : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	
	
	----------------Stage 5-----------------------
	COMPONENT ram1kx13_9 is 
		port( 	data9_r : in std_logic_vector(15 downto 0);
				Q9_r : out std_logic_vector(15 downto 0);
				WAddress_5 : in  std_logic_vector(2 downto 0); 
				RAddress_5 : in  std_logic_vector(2 downto 0);
				WE_5, RE_5 ,WClock,RClock  : in std_logic;
				data9_i : in std_logic_vector(15 downto 0);
				Q9_i: out std_logic_vector(15 downto 0)
		  );
	end COMPONENT ;
	
	COMPONENT ram1kx13_10 is 
		port( 
				data10_r : in std_logic_vector(15 downto 0);
				Q10_r : out std_logic_vector(15 downto 0);
				WAddress_5 : in  std_logic_vector(2 downto 0); 
				RAddress_5 : in  std_logic_vector(2 downto 0);
				WE_5, RE_5 ,WClock,RClock  : in std_logic;
				data10_i : in std_logic_vector(15 downto 0);
				Q10_i: out std_logic_vector(15 downto 0)
		  );
	end COMPONENT ;

	component Mux_2_16bits_bf5 is
		Port ( 	sel : in  STD_LOGIC;
				in1_r : in  STD_LOGIC_VECTOR (15 downto 0);
				in1_i : in  STD_LOGIC_VECTOR (15 downto 0);
				in2_r : in  STD_LOGIC_VECTOR (15 downto 0);
				in2_i : in  STD_LOGIC_VECTOR (15 downto 0);
				  
			    mux_out_16bits_r : out  STD_LOGIC_VECTOR (15 downto 0);
				mux_out_16bits_i : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	------------------Stage 6--------------------------
	
	component ram1kx13_11 is
		 port( 
				data11_r : in std_logic_vector(15 downto 0);
				Q11_r : out std_logic_vector(15 downto 0);
				WAddress_6 : in  std_logic_vector(1 downto 0); 
				RAddress_6 : in  std_logic_vector(1 downto 0);
				WE_6, RE_6 ,WClock,RClock  : in std_logic;
				data11_i : in std_logic_vector(15 downto 0);
				Q11_i : out std_logic_vector(15 downto 0)
		);
	end component;
	component ram1kx13_12 is
		port( 
				data12_r : in std_logic_vector(15 downto 0);
				Q12_r : out std_logic_vector(15 downto 0);
				WAddress_6 : in  std_logic_vector(1 downto 0); 
				RAddress_6 : in  std_logic_vector(1 downto 0);
				WE_6, RE_6 ,WClock,RClock  : in std_logic;
				data12_i : in std_logic_vector(15 downto 0);
				Q12_i : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component BFII is
		Port (     por   : in std_logic;
				a2_r  : in std_logic_vector(Bi - 1 downto 0);
				a2_i  : in std_logic_vector(Bi - 1 downto 0);
				a21_r : in std_logic_vector(Bi - 1 downto 0);
				a21_i : in std_logic_vector(Bi - 1 downto 0);
				i     : in std_logic;
				i1    : in std_logic;
				i4    : in std_logic;
				W_r   : in std_logic_vector(Bi - 1 downto 0);
				W_i   : in std_logic_vector(Bi - 1 downto 0);
				b2_r  : out std_logic_vector(Bi-1 downto 0);
				b2_i  : out std_logic_vector(Bi-1 downto 0);
				b21_r : out std_logic_vector(Bi-1 downto 0);
				b21_i : out std_logic_vector(Bi-1 downto 0)
			 );
	end component;
	--------------Stage 7-------------------
	-- Reuse bf_1, shift register
	--------------------Stage 8-------------------
	COMPONENT bf6_m is
		Port ( 	por   : in std_logic;
				a2_r  : in std_logic_vector(Bi - 1 downto 0);
				a2_i  : in std_logic_vector(Bi - 1 downto 0);
				a21_r : in std_logic_vector(Bi - 1 downto 0);
				a21_i : in std_logic_vector(Bi - 1 downto 0);
				i     : in std_logic;
				i1    : in std_logic;
				i4    : in std_logic;
				b2_r  : out std_logic_vector(Bi-1 downto 0);
				b2_i  : out std_logic_vector(Bi-1 downto 0);
				b21_r : out std_logic_vector(Bi-1 downto 0);
				b21_i : out std_logic_vector(Bi-1 downto 0)
				 ); 
	end COMPONENT ;
	


	signal iwin : integer;
	type data_stream_win is array(1 to 256) of std_logic_vector(Bi - 1 downto 0);
	signal Window_Re   : std_logic_vector(Bi - 1 downto 0);
	signal wx_i : std_logic_vector(15 downto 0);
	signal wx_r : std_logic_vector(15 downto 0);


	
	
	
	---------clk and counters declaration--------------------
	
	signal ii     : integer ;
	signal i16     : integer ;
	signal i64     : integer ;
	signal clk1   : std_logic_vector(7 downto 0);
	signal cnt : std_logic_vector(7 downto 0);
	signal clk2   : std_logic_vector(7 downto 0);
	signal clk3   : std_logic_vector(7 downto 0);
	signal clk4   : std_logic_vector(7 downto 0);
	signal clk5   : std_logic_vector(7 downto 0);
	signal clk6   : std_logic_vector(7 downto 0);
	signal start	:std_logic:='0';
	----------- twiddle declaration --------------------------
	signal WRe   : std_logic_vector(Bi - 1 downto 0);
	signal WIm    : std_logic_vector(Bi - 1 downto 0);
	signal WRe64   : std_logic_vector(Bi - 1 downto 0);
	signal WIm64    : std_logic_vector(Bi - 1 downto 0);
	signal WRe256   : std_logic_vector(Bi - 1 downto 0);
	signal WIm256   : std_logic_vector(Bi - 1 downto 0);
	type data_stream is array(1 to 256) of std_logic_vector(Bi - 1 downto 0);
	type data_stream16 is array(1 to 16) of std_logic_vector(Bi - 1 downto 0);
	type data_stream64 is array(1 to 64) of std_logic_vector(Bi - 1 downto 0);
	
	------------Bit Reversal to normal ----------------------------------------------
	type data_stream11 is array(0 to 255) of integer;
	signal ind,j : integer range 0 to 255;
	signal ind1:std_logic_vector(7 downto 0);
	signal j1:std_logic_vector(8 downto 0);
	
	signal ou_Re:data_stream;
	signal ou_Im:data_stream;
	-------------------------------------------------------------
	
	-------------------------------------------------------------
	signal tran_en : std_logic;
	signal transition_counter : std_logic_vector(8 downto 0);
	-------------------------------------------------------------
	--------------------------------------------------------------
	--Stage 1 signals
	signal reg1_1   : std_logic_vector(Bi - 1 downto 0);
	signal ieg1_1   : std_logic_vector(Bi - 1 downto 0);
	signal reg1_waddress   : std_logic_vector(6 downto 0);
	signal reg1_raddress   : std_logic_vector(6 downto 0);
	signal reg1_we   : std_logic;
	signal reg1_re   : std_logic;
	signal wclock   : std_logic;
	signal rclock   : std_logic;
	signal fb_r_1   : std_logic_vector(Bi - 1 downto 0);
	signal fb_i_1   : std_logic_vector(Bi - 1 downto 0);
	signal c_reg1   : std_logic_vector(Bi - 1 downto 0);
	signal c_ieg1   : std_logic_vector(Bi - 1 downto 0);
	signal reg1_2   : std_logic_vector(Bi - 1 downto 0);
	signal ieg1_2   : std_logic_vector(Bi - 1 downto 0);
	signal en   : std_logic;
	signal op_bf1_r   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf1_i   : std_logic_vector(Bi - 1 downto 0);
	signal temp1_m,temp2_m:std_logic_vector(Bi -1  downto 0);

	--Stage 2 signals
	signal reg2_waddress   : std_logic_vector(5 downto 0);
	signal reg2_raddress   : std_logic_vector(5 downto 0);
	signal reg2_we   : std_logic;
	signal reg2_re   : std_logic;
	signal reg2_1   : std_logic_vector(Bi - 1 downto 0);
	signal ieg2_1   : std_logic_vector(Bi - 1 downto 0);
	signal reg2_2   : std_logic_vector(Bi - 1 downto 0);
	signal ieg2_2   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf2_a1_r   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf2_a1_i   : std_logic_vector(Bi - 1 downto 0);
	signal fb_r_2   : std_logic_vector(Bi - 1 downto 0);
	signal fb_i_2   : std_logic_vector(Bi - 1 downto 0);
	signal c_reg2   : std_logic_vector(Bi - 1 downto 0);
	signal c_ieg2   : std_logic_vector(Bi - 1 downto 0);
	signal en_bf2   : std_logic;

	--Stage 3 signals
	signal reg3_waddress   : std_logic_vector(4 downto 0);
	signal reg3_raddress   : std_logic_vector(4 downto 0);
	signal reg3_we   : std_logic;
	signal reg3_re   : std_logic;
	signal reg3_1   : std_logic_vector(Bi - 1 downto 0);
	signal ieg3_1   : std_logic_vector(Bi - 1 downto 0);
	signal reg3_2   : std_logic_vector(Bi - 1 downto 0);
	signal ieg3_2   : std_logic_vector(Bi - 1 downto 0);
	signal fb_r_3   : std_logic_vector(Bi - 1 downto 0);
	signal fb_i_3   : std_logic_vector(Bi - 1 downto 0);
	signal c_reg3   : std_logic_vector(Bi - 1 downto 0);
	signal c_ieg3   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf3_a1_r   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf3_a1_i   : std_logic_vector(Bi - 1 downto 0);
	signal en_bf3   : std_logic;

	--Stage 4 signals
	signal reg4_waddress   : std_logic_vector(3 downto 0);
	signal reg4_raddress   : std_logic_vector(3 downto 0);
	signal reg4_we   : std_logic;
	signal reg4_re   : std_logic;
	signal reg4_1   : std_logic_vector(Bi - 1 downto 0);
	signal ieg4_1   : std_logic_vector(Bi - 1 downto 0);
	signal reg4_2   : std_logic_vector(Bi - 1 downto 0);
	signal ieg4_2   : std_logic_vector(Bi - 1 downto 0);
	signal fb_r_4   : std_logic_vector(Bi - 1 downto 0);
	signal fb_i_4   : std_logic_vector(Bi - 1 downto 0);
	signal c_reg4   : std_logic_vector(Bi - 1 downto 0);
	signal c_ieg4   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf4_a1_r   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf4_a1_i   : std_logic_vector(Bi - 1 downto 0);
	signal en_bf4   : std_logic;
	
	--STage 5 signals
	signal reg5_waddress   : std_logic_vector(2 downto 0);
	signal reg5_raddress   : std_logic_vector(2 downto 0);
	signal reg5_we   : std_logic;
	signal reg5_re   : std_logic;
	signal reg5_1   : std_logic_vector(Bi - 1 downto 0);
	signal ieg5_1   : std_logic_vector(Bi - 1 downto 0);
	signal reg5_2   : std_logic_vector(Bi - 1 downto 0);
	signal ieg5_2   : std_logic_vector(Bi - 1 downto 0);
	signal fb_r_5   : std_logic_vector(Bi - 1 downto 0);
	signal fb_i_5   : std_logic_vector(Bi - 1 downto 0);
	signal c_reg5   : std_logic_vector(Bi - 1 downto 0);
	signal c_ieg5   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf5_a1_r   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf5_a1_i   : std_logic_vector(Bi - 1 downto 0);
	signal en_bf5   : std_logic;
	
	
	--Stage 6 signals
	signal reg6_waddress   : std_logic_vector(1 downto 0);
	signal reg6_raddress   : std_logic_vector(1 downto 0);
	signal reg6_we   : std_logic;
	signal reg6_re   : std_logic;
	signal reg6_1   : std_logic_vector(Bi - 1 downto 0);
	signal ieg6_1   : std_logic_vector(Bi - 1 downto 0);
	signal reg6_2   : std_logic_vector(Bi - 1 downto 0);
	signal ieg6_2   : std_logic_vector(Bi - 1 downto 0);
	signal fb_r_6   : std_logic_vector(Bi - 1 downto 0);
	signal fb_i_6   : std_logic_vector(Bi - 1 downto 0);
	signal c_reg6   : std_logic_vector(Bi - 1 downto 0);
	signal c_ieg6   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf6_a1_r   : std_logic_vector(Bi - 1 downto 0);
	signal op_bf6_a1_i   : std_logic_vector(Bi - 1 downto 0);
	signal en_bf6   : std_logic;
	
	
	--Stage 7 signals
	
	signal R20_r  : std_logic_vector(Bi - 1 downto 0);
    signal R21_r  : std_logic_vector(Bi - 1 downto 0);
	signal R20_i  : std_logic_vector(Bi - 1 downto 0);
	signal R21_i  : std_logic_vector(Bi - 1 downto 0);
    signal c2o_r  : std_logic_vector(Bi - 1 downto 0);
    signal c2o_i  : std_logic_vector(Bi - 1 downto 0);
	--Stage 8 signals
	
	signal R30_r  : std_logic_vector(Bi - 1 downto 0);
	signal R30_i  : std_logic_vector(Bi - 1 downto 0);
	signal c3o_r  : std_logic_vector(Bi - 1 downto 0); 
	signal c3o_i  : std_logic_vector(Bi - 1 downto 0); 
	signal c_r : std_logic_vector(Bi-1 downto 0);
	signal c_i : std_logic_vector(Bi-1  downto 0);
	
	
	--Magnitude signals
	signal sq :  std_logic_vector(31 downto 0):=(others=>'0');
	
	---Summing circuit
	type MEM is array (0 to 255) of std_logic_vector(31 downto 0);
	signal ramTmp : MEM :=(others=>(others=>'0'));
	signal A: std_logic_vector(31 downto 0);
	signal B: std_logic_vector(31 downto 0);
	signal addr: integer range 0 to 255;
	signal frame_counter: integer range 0 to 255;
	signal sum: std_logic_vector(31 downto 0);
	signal output_sum: std_logic_vector(31 downto 0);
	signal max_magnitude: std_logic_vector(31 downto 0);
	
	
	--- end declarations -----------------------------------
	
	
constant win_coeff: data_stream_win:=(
				  x"0000",	x"0005",	x"0014",	x"002D",	x"0050",	x"007C",	x"00B3",	x"00F3",	x"013D",	x"0191",	x"01EF",	x"0256",	x"02C7",	x"0341",	x"03C5",	x"0452",
				  x"04E9",	x"0589",	x"0631",	x"06E3",	x"079E",	x"0861",	x"092D",	x"0A01",	x"0ADE",	x"0BC3",	x"0CB1",	x"0DA6",	x"0EA3",	x"0FA8",	x"10B4",	x"11C8",
				  x"12E3",	x"1404",	x"152D",	x"165C",	x"1792",	x"18CE",	x"1A10",	x"1B58",	x"1CA6",	x"1DF9",	x"1F52",	x"20AF",	x"2212",	x"2379",	x"24E5",	x"2654",	x"27C8",	x"2940",	x"2ABB",	x"2C39",	x"2DBB",	x"2F3F",	x"30C6",	x"324F",	x"33DA",	x"3568",	x"36F6",	x"3887",	x"3A18",	x"3BAB",	x"3D3E",	x"3ED1",
				  x"4065",	x"41F9",	x"438C",	x"451F",	x"46B1",	x"4842",	x"49D1",	x"4B5F",	x"4CEC",	x"4E76",	x"4FFE",	x"5184",	x"5307",	x"5487",	x"5603",	x"577D",
				  x"58F2",	x"5A64",	x"5BD2",	x"5D3B",	x"5EA0",	x"6000",	x"615B",	x"62B1",	x"6402",	x"654C",	x"6692",	x"67D1",	x"690A",	x"6A3C",	x"6B68",	x"6C8D",
				  x"6DAC",	x"6EC3",	x"6FD3",	x"70DC",	x"71DC",	x"72D6",	x"73C7",	x"74B0",	x"7591",	x"766A",	x"773A",	x"7802",	x"78C1",	x"7977",	x"7A24",	x"7AC8",	x"7B64",	x"7BF5",	x"7C7E",	x"7CFD",	x"7D73",	x"7DDF",	x"7E41",	x"7E9A",	x"7EE9",	x"7F2E",	x"7F6A",	x"7F9B",	x"7FC3",	x"7FE1",	x"7FF5",	x"7FFF",
				  x"7FFF",	x"7FF5",	x"7FE1",	x"7FC3",	x"7F9B",	x"7F6A",	x"7F2E",	x"7EE9",	x"7E9A",	x"7E41",	x"7DDF",	x"7D73",	x"7CFD",	x"7C7E",	x"7BF5",	x"7B64",
				  x"7AC8",	x"7A24",	x"7977",	x"78C1",	x"7802",	x"773A",	x"766A",	x"7591",	x"74B0",	x"73C7",	x"72D6",	x"71DC",	x"70DC",	x"6FD3",	x"6EC3",	x"6DAC",
				  x"6C8D",	x"6B68",	x"6A3C",	x"690A",	x"67D1",	x"6692",	x"654C",	x"6402",	x"62B1",	x"615B",	x"6000",	x"5EA0",	x"5D3B",	x"5BD2",	x"5A64",	x"58F2",	x"577D",	x"5603",	x"5487",	x"5307",	x"5184",	x"4FFE",	x"4E76",	x"4CEC",	x"4B5F",	x"49D1",	x"4842",	x"46B1",	x"451F",	x"4391",	x"41F9",	x"4065",	x"3ED1",	x"3D3E",	x"3BAB",	x"3A18",	x"3887",	x"36F6",	x"3568",	x"33DA",	x"324F",	x"30C6",	x"2F3F",	x"2DBB",	x"2C39",	x"2ABB",	x"2940",	x"27C8",
				  x"2654",	x"24E5",	x"2379",	x"2212",	x"20AF",	x"1F52",	x"1DF9",	x"1CA6",	x"1B58",	x"1A10",	x"18CE",	x"1792",	x"165C",	x"152D",	x"1404",	x"12E3",
				  x"11C8",	x"10B4",	x"0FA8",	x"0EA3",	x"0DA6",	x"0CB1",	x"0BC3",	x"0ADE",	x"0A01",	x"092D",	x"0861",	x"079E",	x"06E3",	x"0631",	x"0589",	x"04E9",
				  x"0452",	x"03C5",	x"0341",	x"02C7",	x"0256",	x"01EF",	x"0191",	x"013D",	x"00F3",	x"00B3",	x"007C",	x"0050",	x"002D",	x"0014",	x"0005",	x"0000"
					);		
	
constant WW_Re:data_stream := (x"89C0",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E",x"89C0",
										 x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"5A82",x"0000",x"A57E",x"7FFF",x"763F",x"5A82",x"30FC",x"7FFF",x"30FC",x"A57E");

constant WW_Re64:data_stream :=(x"7FFF",x"7FFF",x"7FFF",
                                x"7FFF",x"7DFB",x"75EB",x"6AD5",x"5AB5",x"478F",x"3162",x"1932",x"0000",x"E7CE",x"CFA0",x"B973",x"A54B",x"952B",x"8A16",x"8205",                                
                                x"7FFF",x"7EFD",x"7DFB",x"7AF5",x"75EB",x"70E1",x"6AD5",x"62C5",x"5AB5",x"51A3",x"478F",x"3C78",x"3162",x"254A",x"1932",x"0D1A",
                                x"7FFF",x"7AF5",x"6AD5",x"51A3",x"3162",x"0D1A",x"E6CE",x"C388",x"A54B",x"8F1F",x"8205",x"8103",x"8A16",x"9D3B",x"B871",x"DAB6",
										  x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",
                                x"7FFF",x"7DFB",x"75EB",x"6AD5",x"5AB5",x"478F",x"3162",x"1932",x"0000",x"E7CE",x"CFA0",x"B973",x"A54B",x"952B",x"8A16",x"8205",                                
                                x"7FFF",x"7EFD",x"7DFB",x"7AF5",x"75EB",x"70E1",x"6AD5",x"62C5",x"5AB5",x"51A3",x"478F",x"3C78",x"3162",x"254A",x"1932",x"0D1A",
                                x"7FFF",x"7AF5",x"6AD5",x"51A3",x"3162",x"0D1A",x"E6CE",x"C388",x"A54B",x"8F1F",x"8205",x"8103",x"8A16",x"9D3B",x"B871",x"DAB6",
										  x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",
                                x"7FFF",x"7DFB",x"75EB",x"6AD5",x"5AB5",x"478F",x"3162",x"1932",x"0000",x"E7CE",x"CFA0",x"B973",x"A54B",x"952B",x"8A16",x"8205",                                
                                x"7FFF",x"7EFD",x"7DFB",x"7AF5",x"75EB",x"70E1",x"6AD5",x"62C5",x"5AB5",x"51A3",x"478F",x"3C78",x"3162",x"254A",x"1932",x"0D1A",
                                x"7FFF",x"7AF5",x"6AD5",x"51A3",x"3162",x"0D1A",x"E6CE",x"C388",x"A54B",x"8F1F",x"8205",x"8103",x"8A16",x"9D3B",x"B871",x"DAB6",
										  x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",
                                x"7FFF",x"7DFB",x"75EB",x"6AD5",x"5AB5",x"478F",x"3162",x"1932",x"0000",x"E7CE",x"CFA0",x"B973",x"A54B",x"952B",x"8A16",x"8205",                                
                                x"7FFF",x"7EFD",x"7DFB",x"7AF5",x"75EB",x"70E1",x"6AD5",x"62C5",x"5AB5",x"51A3",x"478F",x"3C78",x"3162",x"254A",x"1932",x"0D1A",
                                x"7FFF",x"7AF5",x"6AD5",x"51A3",x"3162",x"0D1A",x"E6CE",x"C388",x"A54B",x"8F1F",x"8205",x"8103",x"8A16",x"9D3B",x"B871",x"DAB6",
										  x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF");

constant WW_Re256:data_stream :=(x"7FFF",
											x"7FFF",x"7FD8",x"7F61",x"7E9D",x"7D8A",x"7C2A",x"7A7D",x"7885",x"7643",x"73B8",x"70E6",x"6DCE",x"6A72",x"66D5",x"62F8",x"5EDF",
											x"5A8B",x"55FF",x"513F",x"4C4C",x"472A",x"41DC",x"3C66",x"36CB",x"310D",x"2B32",x"253C",x"1F2F",x"190F",x"12DF",x"0CA4",x"0661",
										   x"001A",x"F9D3",x"F390",x"ED54",x"E724",x"E104",x"DAF6",x"D4FF",x"CF23",x"C965",x"C3C8",x"BE50",x"B901",x"B3DE",x"AEEA",x"AA27",
										   x"A59A",x"A144",x"9D29",x"994A",x"95AB",x"924D",x"8F33",x"8C5E",x"89D1",x"878C",x"8592",x"83E3",x"8280",x"816B",x"80A4",x"802B",	 
										   x"7FFF",x"7FF5",x"7FD8",x"7FA6",x"7F61",x"7F09",x"7E9D",x"7E1D",x"7D8A",x"7CE4",x"7C2A",x"7B5D",x"7A7D",x"798B",x"7885",x"776E",
										   x"7643",x"7507",x"73B8",x"7258",x"70E6",x"6F62",x"6DCE",x"6C28",x"6A72",x"68AC",x"66D5",x"64EF",x"62F8",x"60F3",x"5EDF",x"5CBC",
										   x"5A8B",x"584C",x"55FF",x"53A5",x"513F",x"4ECB",x"4C4C",x"49C1",x"472A",x"4488",x"41DC",x"3F26",x"3C66",x"399D",x"36CB",x"33F0",  
										   x"310D",x"2E23",x"2B32",x"283A",x"253C",x"2238",x"1F2F",x"1C21",x"190F",x"15F9",x"12DF",x"0FC3",x"0CA4",x"0983",x"0661",x"033E",
										   x"7FFF",x"7FA6",x"7E9D",x"7CE4",x"7A7D",x"776E",x"73B8",x"6F62",x"6A72",x"64EF",x"5EDF",x"584C",x"513F",x"49C1",x"41DC",x"399D",
										   x"310D",x"283A",x"1F2F",x"15F9",x"0CA4",x"033E",x"F9D3",x"F071",x"E724",x"DDFA",x"D4FF",x"CC40",x"C3C8",x"BBA4",x"B3DE",x"AC82",
										   x"A59A",x"9F2F",x"994A",x"93F4",x"8F33",x"8B0E",x"878C",x"84B1",x"8280",x"80FE",x"802B",x"800A",x"809A",x"81DA",x"83C9",x"8665",
										   x"89A9",x"8D91",x"9217",x"9736",x"9CE6",x"A320",x"A9DA",x"B10C",x"B8AB",x"C0AD",x"C906",x"D1AC",x"DA92",x"E3AC",x"ECED",x"F649",
											x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",
											x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",
											x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",
											x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF",x"7FFF");



--------------------------------------------

-----imag parts-twiddle--------------------



constant WW_Im:data_stream :=(x"30FC",x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E",x"30FC",
										x"0000",x"0000",x"0000",x"0000",x"0000",x"A57E",x"8001",x"A57E",x"0000",x"CF03",x"A57E",x"89C0",x"0000",x"89C0",x"A57E");



constant WW_Im64:data_stream :=(x"0000",x"0000",x"0000",
										  x"0000",x"E6CE",x"CE9E",x"B871",x"A54B",x"952B",x"8A16",x"8205",x"8001",x"8205",x"8A16",x"952B",x"A54B",x"B871",x"CE9E",x"E6CE",
                                x"0000",x"F3E8",x"E6CE",x"DAB6",x"CE9E",x"C388",x"B871",x"AE5D",x"A54B",x"9D3B",x"952B",x"8F1F",x"8A16",x"850B",x"8205",x"8103",
                                x"0000",x"DAB6",x"B871",x"9D3B",x"8A16",x"8103",x"8205",x"8F1F",x"A54B",x"C388",x"E6CE",x"0C18",x"3162",x"51A3",x"6AD5",x"78F5",
										  x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
										  x"0000",x"E6CE",x"CE9E",x"B871",x"A54B",x"952B",x"8A16",x"8205",x"8001",x"8205",x"8A16",x"952B",x"A54B",x"B871",x"CE9E",x"E6CE",
                                x"0000",x"F3E8",x"E6CE",x"DAB6",x"CE9E",x"C388",x"B871",x"AE5D",x"A54B",x"9D3B",x"952B",x"8F1F",x"8A16",x"850B",x"8205",x"8103",
                                x"0000",x"DAB6",x"B871",x"9D3B",x"8A16",x"8103",x"8205",x"8F1F",x"A54B",x"C388",x"E6CE",x"0C18",x"3162",x"51A3",x"6AD5",x"78F5",
										  x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
										  x"0000",x"E6CE",x"CE9E",x"B871",x"A54B",x"952B",x"8A16",x"8205",x"8001",x"8205",x"8A16",x"952B",x"A54B",x"B871",x"CE9E",x"E6CE",
                                x"0000",x"F3E8",x"E6CE",x"DAB6",x"CE9E",x"C388",x"B871",x"AE5D",x"A54B",x"9D3B",x"952B",x"8F1F",x"8A16",x"850B",x"8205",x"8103",
                                x"0000",x"DAB6",x"B871",x"9D3B",x"8A16",x"8103",x"8205",x"8F1F",x"A54B",x"C388",x"E6CE",x"0C18",x"3162",x"51A3",x"6AD5",x"78F5",
										  x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
										  x"0000",x"E6CE",x"CE9E",x"B871",x"A54B",x"952B",x"8A16",x"8205",x"8001",x"8205",x"8A16",x"952B",x"A54B",x"B871",x"CE9E",x"E6CE",
                                x"0000",x"F3E8",x"E6CE",x"DAB6",x"CE9E",x"C388",x"B871",x"AE5D",x"A54B",x"9D3B",x"952B",x"8F1F",x"8A16",x"850B",x"8205",x"8103",
                                x"0000",x"DAB6",x"B871",x"9D3B",x"8A16",x"8103",x"8205",x"8F1F",x"A54B",x"C388",x"E6CE",x"0C18",x"3162",x"51A3",x"6AD5",x"78F5",
										  x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
										  
										 

constant WW_Im256:data_stream :=(							X"0000",
											X"0000",X"F9B9",X"F376",X"ED3B",X"E70B",X"E0EA",X"DADD",X"D4E7",X"CF0B",X"C94D",X"C3B1",X"BE3A",X"B8EC",X"B3C9",X"AED6",X"AA14",
											X"A587",X"A133",X"9D18",X"993B",X"959C",X"9240",X"8F27",X"8C53",X"89C7",X"8783",X"858A",X"83DC",X"827B",X"8167",X"80A1",X"802A",
											X"8001",X"8027",X"809C",X"815F",X"8271",X"83D0",X"857B",X"8772",X"89B3",X"8C3D",X"8F0E",X"9225",X"957F",X"991B",X"9CF7",X"A110",
											X"A563",X"A9ED",X"AEAD",X"B39F",X"B8C0",X"BE0D",X"C383",X"C91E",X"CEDA",X"D4B5",X"DAAB",X"E0B8",X"E6D7",X"ED07",X"F342",X"F985",
											X"0000",X"FCDC",X"F9B9",X"F697",X"F376",X"F057",X"ED3B",X"EA21",X"E70B",X"E3F8",X"E0EA",X"DDE1",X"DADD",X"D7DF",X"D4E7",X"D1F5",
											X"CF0B",X"CC28",X"C94D",X"C67B",X"C3B1",X"C0F1",X"BE3A",X"BB8E",X"B8EC",X"B655",X"B3C9",X"B149",X"AED6",X"AC6E",X"AA14",X"A7C7",
											X"A587",X"A356",X"A133",X"9F1E",X"9D18",X"9B22",X"993B",X"9763",X"959C",X"93E6",X"9240",X"90AB",X"8F27",X"8DB4",X"8C53",X"8B04",
											X"89C7",X"889C",X"8783",X"867D",X"858A",X"84AA",X"83DC",X"8322",X"827B",X"81E7",X"8167",X"80FA",X"80A1",X"805C",X"802A",X"800C",
											X"0000",X"F697",X"ED3B",X"E3F8",X"DADD",X"D1F5",X"C94D",X"C0F1",X"B8EC",X"B149",X"AA14",X"A356",X"9D18",X"9763",X"9240",X"8DB4",
											X"89C7",X"867D",X"83DC",X"81E7",X"80A1",X"800C",X"8027",X"80F4",X"8271",X"849C",X"8772",X"8AEF",X"8F0E",X"93CA",X"991B",X"9EFC",
											X"A563",X"AC47",X"B39F",X"BB62",X"C383",X"CBF8",X"D4B5",X"DDAF",X"E6D7",X"F023",X"F985",X"02F0",X"0C56",X"15AC",X"1EE3",X"27F0",
											X"30C5",X"3957",X"4199",X"4980",X"5102",X"5813",X"5EAA",X"64BE",X"6A47",X"6F3C",X"7397",X"7751",X"7A67",X"7CD2",X"7E91",X"7FA0",
											X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
											X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
											X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
											X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000");










	-------------------------------------------------------------------------------------
	
	-----Bit Reversal to normal index definition---------------
	constant index:data_stream11 :=(0,128,64,192,32,160,96,224,16,144,80,208,48,176,112,240,8,136,72,200,40,168,104,232,24,152,88,216,56,184,120,248,4,132,68,196,36,164,100,228,20,148,84,212,52,180,116,244,12,140,76,204,44,172,108,236,28,156,92,220,60,188,124,252,2,130,66,194,34,162,98,226,18,146,82,210,50,178,114,242,10,138,74,202,42,170,106,234,26,154,90,218,58,186,122,250,6,134,70,198,38,166,102,230,22,150,86,214,54,182,118,246,14,142,78,206,46,174,110,238,30,158,94,222,62,190,126,254,1,129,65,193,33,161,97,225,17,145,81,209,49,177,113,241,9,137,73,201,41,169,105,233,25,153,89,217,57,185,121,249,5,133,69,197,37,165,101,229,21,149,85,213,53,181,117,245,13,141,77,205,45,173,109,237,29,157,93,221,61,189,125,253,3,131,67,195,35,163,99,227,19,147,83,211,51,179,115,243,11,139,75,203,43,171,107,235,27,155,91,219,59,187,123,251,7,135,71,199,39,167,103,231,23,151,87,215,55,183,119,247,15,143,79,207,47,175,111,239,31,159,95,223,63,191,127,255);
	-----------------------------------------------------------
	
	
	
	
	
	-- ARCHITECTURE BEGIN----
	begin
		clk2 <= clk1-1;
		clk3 <= clk2-1;
		clk4 <= clk3-1;
		clk5 <= clk4-1;
		clk6 <= clk5-1;
	 
		ind1<=conv_std_logic_vector(ind,8);
		j1<='0'&ind1(0)&ind1(1)&ind1(2)&ind1(3)&ind1(4)&ind1(5)&ind1(6)&ind1(7);

	
	----Component Instantiation--------------------------------
	
	--temp1_m<=c_reg1(8)&c_reg1(8)&c_reg1(8)&c_reg1(8)&c_reg1(8)&c_reg1(8)&c_reg1(8)&c_reg1;
	--temp2_m<=c_ieg1(8)&c_ieg1(8)&c_ieg1(8)&c_ieg1(8)&c_ieg1(8)&c_ieg1(8)&c_ieg1(8)&c_ieg1;
 
	-------- Stage 1---------------------------------------------
		u_win: Win_multiply port map(	 clk => clk,
				 		 por=>por,
				 		 x_r=>x_r,
				 		 x_i=>x_i,
				 		 win_co=>Window_Re,
				 		 wx_r=>wx_r,
				 		 wx_i=>wx_i	
							);			


		u0: ram1kx13_1 port map (	data1_r =>wx_r,
						Q1_r=> reg1_1,
												
						WAddress_1 => reg1_waddress,
						RAddress_1 => reg1_raddress,
												
						WE_1 => reg1_we,
						RE_1 => reg1_re,
												
						WClock => wclock,
						RClock => rclock,
												
						data1_i =>wx_i,
						Q1_i=> ieg1_1
					);
								 
														 
		ram1kx13_2_0: ram1kx13_2 port map (
							data2_r => fb_r_1,
							Q2_r=> reg1_2,
							WAddress_1 => reg1_waddress,
							RAddress_1 => reg1_raddress,
							WE_1 => reg1_we,
							RE_1 => reg1_re,
							WClock => wclock,
							RClock => rclock,
							data2_i => fb_i_1,
							Q2_i=> ieg1_2
						);  
    
		bf1_m_0: bf1_m  port map (	
							por => por,
							a_r => wx_r,
							a_i => wx_i,
							a1_r => op_bf1_r,
							a1_i => op_bf1_i,							 
							i2 => clk1(7), -- corrected
							i3 => clk,
							b_r => fb_r_1,
							b_i => fb_i_1,
							b1_r => c_reg1,
							b1_i => c_ieg1
						);
  
		Mux_2_16bits_0: Mux_2_16bits port map( 
								
							sel => en,
							in1_r =>reg1_1,
							in1_i =>ieg1_1,
							in2_r => reg1_2,
							in2_i => ieg1_2,
							mux_out_16bits_r => op_bf1_r,
							mux_out_16bits_i => op_bf1_i										  
								
							);
		
								 
	------------end of Stage 1-------------------------------------------
	
	--------------Stage 2-----------------------------------------------
		ram1kx13_3_0: ram1kx13_3 port map (
							data3_r=>c_reg1,
							Q3_r=> reg2_1,
												
							WAddress_2 => reg2_waddress,
							RAddress_2 => reg2_raddress,
												
							WE_2 => reg2_we,
							RE_2 => reg2_re,
												
							WClock => wclock,
							RClock => rclock,
										
							data3_i=>c_ieg1,
							Q3_i=> ieg2_1
						);
  
		ram1kx13_4_0: ram1kx13_4 port map (
							data4_r => fb_r_2,
							Q4_r=> reg2_2,
							WAddress_2 => reg2_waddress,
							RAddress_2 => reg2_raddress,
							WE_2 => reg2_we,
							RE_2 => reg2_re,
							WClock => wclock,
							RClock => rclock,
							data4_i => fb_i_2,
							Q4_i=> ieg2_2
							); 
		
		bf2_m_0: bf2_m  port map (	
							por => por,
												
							a2_r=>c_reg1 , --!!
																						
							
												
							a2_i=> c_ieg1 , --!!
							
																							
							
												
							a21_r => op_bf2_a1_r,
							a21_i => op_bf2_a1_i,							 
							i => clk2(6), -- corrected
							i1 => clk2(7), -- corrected
							i4 => clk,
							W_r => WRe256,
							W_i => WIm256,
							b2_r => fb_r_2,
							b2_i => fb_i_2,
							b21_r => c_reg2,
							b21_i => c_ieg2
									); 

		Mux_2_16bits_bf2_0 : Mux_2_16bits_bf2 port map( 
								sel => en_bf2,
								in1_r => reg2_1,
								in1_i => ieg2_1,
								in2_r => reg2_2,
								in2_i => ieg2_2,				  
								mux_out_16bits_r => op_bf2_a1_r,
								mux_out_16bits_i => op_bf2_a1_i										  
							);	
		 
		
	------------end of Stage 2------------------------------------------
	
	--------------Stage 3-----------------------------------------------
		ram1kx13_5_0: ram1kx13_5 port map (
							data5_r => c_reg2,
							Q5_r   => reg3_1,
							WAddress_3 => reg3_waddress,
							RAddress_3 => reg3_raddress,
							WE_3 => reg3_we,
							RE_3 => reg3_re,
							WClock => wclock,
							RClock => rclock,
							data5_i => c_ieg2,
							Q5_i=> ieg3_1
						);  
		
		ram1kx13_6_0: ram1kx13_6 port map (
							data6_r => fb_r_3,
							Q6_r   => reg3_2,
							WAddress_3 => reg3_waddress,
							RAddress_3 => reg3_raddress,
							WE_3 => reg3_we,
							RE_3 => reg3_re,
							WClock => wclock,
							RClock => rclock,
							data6_i => fb_i_3,
							Q6_i   => ieg3_2
						);
		
		Mux_2_16bits_bf3_0 : Mux_2_16bits_bf3 port map( 
								sel => en_bf3,
								in1_r => reg3_1,
								in1_i => ieg3_1,
								in2_r => reg3_2,
								in2_i => ieg3_2,
																		  
								mux_out_16bits_r => op_bf3_a1_r,
								mux_out_16bits_i => op_bf3_a1_i	
														
								);								 

		bf1_m_15_0: bf1_m_15  port map (
								por => por,
								a_r => c_reg2,
								a_i => c_ieg2,
								a1_r => op_bf3_a1_r,
								a1_i => op_bf3_a1_i,							 
								i2 => clk3(5), -- corrected
								i3 => clk,
								b_r => fb_r_3,
								b_i => fb_i_3,
								b1_r => c_reg3,
								b1_i => c_ieg3
							);
	------------end of Stage 3------------------------------------------
	
	--------------Stage 4-----------------------------------------------
		ram1kx13_7_0: ram1kx13_7 port map (
								data7_r => c_reg3,
								Q7_r => reg4_1,
								WAddress_4 => reg4_waddress,
								RAddress_4 => reg4_raddress,
								WE_4 => reg4_we,
								RE_4 => reg4_re,
								WClock => wclock,
								RClock => rclock,
								data7_i => c_ieg3,
								Q7_i   => ieg4_1
							);  
		ram1kx13_8_0: ram1kx13_8 port map (
								data8_r => fb_r_4,
								Q8_r   => reg4_2,
								WAddress_4 => reg4_waddress,
								RAddress_4 => reg4_raddress,
								WE_4 => reg4_we,
								RE_4 => reg4_re,
								WClock => wclock,
								RClock => rclock,
								data8_i => fb_i_4,
								Q8_i   => ieg4_2
							);
 

		Mux_2_16bits_bf4_0 : Mux_2_16bits_bf4 port map(
								sel => en_bf4,
								in1_r => reg4_1,
								in1_i => ieg4_1,
								in2_r => reg4_2,
								in2_i => ieg4_2,
								mux_out_16bits_r => op_bf4_a1_r,
								mux_out_16bits_i => op_bf4_a1_i										  
							);	
		 
		BFII_0: BFII  port map (
						
						por => por,
						a2_r => c_reg3,
						a2_i => c_ieg3,
						a21_r => op_bf4_a1_r,
						a21_i => op_bf4_a1_i,							 
						i => clk4(4), -- corrected
						i1 => clk4(5), -- corrected
						i4 => clk,
						W_r => WRe64,
						W_i => WIm64,
						b2_r => fb_r_4,
						b2_i => fb_i_4,
						b21_r => c_reg4,
						b21_i => c_ieg4
									); 
	------------end of Stage 4------------------------------------------
	
	--------------Stage 5-----------------------------------------------
		ram1kx13_9_0: ram1kx13_9 port map (
							data9_r => c_reg4,
							Q9_r   => reg5_1,
							WAddress_5 => reg5_waddress,
							RAddress_5 => reg5_raddress,
							WE_5 => reg5_we,
							RE_5 => reg5_re,
							WClock => wclock,
							RClock => rclock,
							data9_i => c_ieg4,
							Q9_i=> ieg5_1
						);  
		
		ram1kx13_10_0: ram1kx13_10 port map (
							data10_r => fb_r_5,
							Q10_r   => reg5_2,
							WAddress_5 => reg5_waddress,
							RAddress_5 => reg5_raddress,
							WE_5 => reg5_we,
							RE_5 => reg5_re,
							WClock => wclock,
							RClock => rclock,
							data10_i => fb_i_5,
							Q10_i   => ieg5_2
						);
		
		Mux_2_16bits_bf5_0 : Mux_2_16bits_bf5 port map( 
								sel => en_bf5,
								in1_r => reg5_1,
								in1_i => ieg5_1,
								in2_r => reg5_2,
								in2_i => ieg5_2,
																		  
								mux_out_16bits_r => op_bf5_a1_r,
								mux_out_16bits_i => op_bf5_a1_i										  
								);								 

		bf1_m_15_1: bf1_m_15  port map (
							por => por,
							a_r => c_reg4,
							a_i => c_ieg4,
							a1_r => op_bf5_a1_r,
							a1_i => op_bf5_a1_i,							 
							i2 => clk5(3),
							i3 => clk,
							b_r => fb_r_5,
							b_i => fb_i_5,
							b1_r => c_reg5,
							b1_i => c_ieg5
						);
	------------end of Stage 5------------------------------------------
	
	--------------Stage 6-----------------------------------------------
		ram1kx13_11_0: ram1kx13_11 port map (
							data11_r => c_reg5,
							Q11_r => reg6_1,
							WAddress_6 => reg6_waddress,
							RAddress_6 => reg6_raddress,
							WE_6 => reg6_we,
							RE_6 => reg6_re,
							WClock => wclock,
							RClock => rclock,
							data11_i => c_ieg5,
							Q11_i   => ieg6_1
						);
  
		ram1kx13_12_0: ram1kx13_12 port map (
							data12_r => fb_r_6,
							Q12_r   => reg6_2,
							WAddress_6 => reg6_waddress,
							RAddress_6 => reg6_raddress,
							WE_6 => reg6_we,
							RE_6 => reg6_re,
							WClock => wclock,
							RClock => rclock,
							data12_i => fb_i_6,
							Q12_i   => ieg6_2
						); 

		Mux_2_16bits_bf4_1: Mux_2_16bits_bf4 port map(
								sel => en_bf6,
								in1_r => reg6_1,
								in1_i => ieg6_1,
								in2_r => reg6_2,
								in2_i => ieg6_2,
								mux_out_16bits_r => op_bf6_a1_r,
								mux_out_16bits_i => op_bf6_a1_i										  
							);	
		 
		BFII_1: BFII  port map (
							por => por,
							a2_r => c_reg5,
							a2_i => c_ieg5,
							a21_r => op_bf6_a1_r,
							a21_i => op_bf6_a1_i,							 
							i => clk6(2),
							i1 => clk6(3),
							i4 => clk,
							W_r => WRe,
							W_i => WIm,
							b2_r => fb_r_6,
							b2_i => fb_i_6,
							b21_r => c_reg6,
							b21_i => c_ieg6
					); 
	------------end of Stage 6------------------------------------------
	
	--------------Stage 7-----------------------------------------------
			--				
		bf1_m_15_2: bf1_m_15  port map (
							por => por,
							a_r => c_reg6,
							a_i => c_ieg6,
							a1_r => R21_r,
							a1_i => R21_i,							 
							i2 => clk3(1),
							i3 => clk,
							b_r => R20_r,
							b_i => R20_i,
							b1_r => c2o_r,
							b1_i => c2o_i
						);
										
	------------end of Stage 7------------------------------------------
	
	--------------Stage 8-----------------------------------------------
	bf6_m_0: bf6_m  port map (
							por => por,
							a2_r => c2o_r,
							a2_i => c2o_i,
							a21_r => R30_r,
							a21_i => R30_i,							 
							i => clk4(0),
							i1 => clk4(1),
							i4 => clk,
							b2_r => R30_r,
							b2_i => R30_i,
							b21_r => c3o_r,
							b21_i => c3o_i
						); 
	------------end of Stage 8------------------------------------------
	
	----------end of component instantiation----------------
	 
		process(por,clk) 
			begin
				if(por='1') then
				cnt<="00000000";
				elsif(rising_edge(clk)) then
					cnt<=cnt+'1';
				end if;
		end process;	 
		
		reg1_waddress <= cnt(6 downto 0);
		reg1_raddress <= cnt(6 downto 0);
		reg1_we <= clk1(7);-- modified
		reg1_re <= clk1(7);-- modified
		wclock <= clk;
		rclock <= clk;
		
		process(por, clk)
			begin
				if(por='1') then
					en<='0';
					en_bf2<='0';
					en_bf3<='0';
					en_bf4<='0';
					en_bf5<='0';
					en_bf6<='0';
				elsif(falling_edge(clk)) then
					en<=clk1(7);
					en_bf2<=clk2(6);
					en_bf3<=clk3(5);
					en_bf4<=clk4(4);
					en_bf5<=clk5(3);
					en_bf6<=clk6(2);
				end if;
			end process;
		
		
		
		-------Define signals for Stage 2-----------
		reg2_waddress <= cnt(5 downto 0);
		reg2_raddress <= cnt(5 downto 0);
		reg2_we <= clk2(6);--to be corrected
		reg2_re <= clk2(6);--to be corrected
		
		
		-------Define signals for Stage 3-----------
		reg3_waddress <= cnt(4 downto 0);
		reg3_raddress <= cnt(4 downto 0);
		reg3_we <= clk3(5);--to be corrected
		reg3_re <= clk3(5);--to be corrected
		
		
		-------Define signals for Stage 4-----------
		reg4_waddress <= cnt(3 downto 0);
		reg4_raddress <= cnt(3 downto 0);
		reg4_we <= clk4(4);--to be corrected
		reg4_re <= clk4(4);--to be corrected
		
		
		-------Define signals for Stage 5-----------
		reg5_waddress <= cnt(2 downto 0);
		reg5_raddress <= cnt(2 downto 0);
		reg5_we <= clk5(3);--to be corrected
		reg5_re <= clk5(3);--to be corrected
		
		
		-------Define signals for Stage 6-----------
		reg6_waddress <= cnt(1 downto 0);
		reg6_raddress <= cnt(1 downto 0);
		reg6_we <= clk6(2);--to be corrected
		reg6_re <= clk6(2);--to be corrected
		
		
		
		
		process(clk, por)
			variable temp_max: std_logic_vector(31 downto 0);
			variable temp_max_index: integer range 0 to 255;
			
			begin
			
				if(por='1') then
					
					clk1<= (others => '0');
					Window_Re<=(others=>'0');
					WRe <= (others => '0');
					WIm <= (others => '0');
					
					WRe64 <= (others => '0');
					WIm64 <= (others => '0');
					
					WRe256 <= (others => '0');
					WIm256 <= (others => '0');
					
					--ou_Re<='0';
					
					
				--    c_r <= (others => '0');
				--	 c_i <= (others => '0'); 
					tran_en <= '0';
					transition_counter <= "000000000";
					ind <=249;
					iwin<=1;
					ii <= 2; 
					i64<=2;
					i16<=2;
					R21_r <= (others => '0'); 
					R21_i <= (others => '0');
					
					
					for i in 1 to 256 loop
						ou_Im(i)<=(others => '0');
						ou_Re(i)<=(others => '0');
					end loop;
					
					
				elsif(rising_edge(clk)) then
					iwin<=(iwin mod 256)+1;
					Window_Re<=win_coeff(iwin);
					ii<=(ii mod 256)+1;
					
					
					clk1<=clk1+1;
					WRe <= WW_Re(ii);
					WIm <= WW_Im(ii);
					WRe64 <= WW_Re64(ii);
					WIm64 <= WW_Im64(ii);
					WRe256 <= WW_Re256(ii);
					WIm256 <= WW_Im256(ii);
					--Introduce i16,i64
					
					--Shift registers for 7th stage
					R21_r<=R20_r;
					R21_i<=R20_i;
					
					
					--c_r<=c3o_r;
					--c_i<=c3o_i;
					
					ou_Re(ind+1) <= c3o_r ; 
					ou_Im(ind+1) <= c3o_i ; 
				
					ind <= (ind +1) mod 256;
					
					c_r <=  ou_Re(index(ind)+1);
					c_i <=  ou_Im(index(ind)+1);
					
					sq <=  (c_r*c_r)+(c_i*c_i);
					A<="000000"&sq(31 downto 6);
					B<=ramTmp((addr+2) mod 256);
					sum<=A+B;
					
					if(frame_counter>=3) then
						magnitude_spectrum<="000000"&sq(31 downto 6);
						
						ramTmp(addr)<=sum;
					end if;
					
					--- Finding the max value
				
					
				elsif(falling_edge(clk)) then
					if(cnt="00001011") then --#1
					
						if(frame_counter=(2+2)) then -- 2+2 indicates 2 frames delay and 2 frames processing
							temp_max:=ramTmp(0);
							temp_max_index:=0;
							for addr1 in 1 to 128 loop
								if(ramTmp(addr1)>temp_max) then
									temp_max:=ramTmp(addr1);
									temp_max_index:=addr1;
								end if;
							end loop;
							max_magnitude<="0000000000"&temp_max(31 downto 10);
							max_mag<=((conv_integer(max_magnitude))*2);
							vib_frequency<=(temp_max_index);
							frame_counter<=3;
							ramTmp<=(others=>(others=>'0'));
						else 
						frame_counter<=frame_counter+1;
						addr<=0;
						end if;--#2
					else
						addr<=(addr+1) mod 256;
					end if;--#1
			
				
				
				end if;
				
			end process;
		
		
		
		ind1_0 <= ind1;
		j1_0 <= j1;
	end Behavioral;
