library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity super_register is 
	generic ( N : integer := 8);
	port( data_in : in std_logic_vector(N-1 downto 0);
	      data_sh_l,data_sh_r,clk : in std_logic;
	      control : in std_logic_vector(2 downto 0);
	       data_out1: buffer std_logic_vector(N-1 downto 0);
	       data_out2: out std_logic);
end super_register;

architecture behavoir of super_register is
begin 
	process(control,clk)
		variable tmp : std_logic;
		variable zero_all : std_logic_vector(N-1 downto 0) := (others => '0') ;
		variable one_all : std_logic_vector(N-1 downto 0) := (others => '1');
	begin 
		if clk'event and clk = '1' then
			case control is 
				when "000" => --load new data
					data_out1 <= data_in;
				when "001" => -- right shift
					l_shift: for i in 0 to N-2 loop
					data_out1(i) <= data_out1(i+1);
					end loop;
					data_out1(N-1) <= data_sh_r;
				when "010" => -- left shift
					r_shift: for i in N-1 downto 1 loop
					data_out1(i) <= data_out1(i-1);
					end loop;
					data_out1(0) <= data_sh_l;
				when "011" => -- left rotate 
					tmp := data_out1(0);
					l_rotate: for i in 0 to N-2 loop
					data_out1(i) <= data_out1(i+1);
					end loop;
					data_out1(N-1) <= tmp;
				when "100" => -- right rotate
					tmp := data_out1(N-1);
					r_rotate: for i in N-1 downto 1 loop
					data_out1(i) <= data_out1(i-1);
					end loop;
					data_out1(0) <= tmp;	
				when "101" => --store present state
					data_out1<=data_out1;
				when "110" => -- count up 
					data_out1 <= data_out1 + 1 ;
				when others => -- count down
					data_out1 <= data_out1 - 1 ;
			end case;

			if(data_out1 = zero_all or data_out1 = one_all) then 
				data_out2 <= '1';
			else 
				data_out2 <= '0';
			end if;

		end if;
	end process;

end behavoir;


