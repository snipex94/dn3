LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.Wallace_tree_functions.all;

ENTITY wallace_addition IS
	GENERIC (
		width : INTEGER := 4;	--širina operanda
		nrargs : INTEGER := 4	--število operandov
	);
	PORT (
		x		:	IN ArrayOfAddends(width - 1  DOWNTO 0, nrargs - 1  DOWNTO 0);		-- polje bitov operandov
		sum	:	OUT STD_LOGIC_VECTOR(sizeof(nrargs * (2**width - 1)) - 1  DOWNTO 0)	-- vsota
	);		
END wallace_addition;

ARCHITECTURE Wallace_unsigned_addition OF wallace_addition IS

component cla_add_n_bit IS
	generic(n: natural := 8);
	PORT (	Cin	:	in 	std_logic;
				X, Y	:	in 	std_logic_vector(n-1 downto 0);
				S		:	out	std_logic_vector(n-1 downto 0);
				Gout, 
				Pout, 
				Cout	:	out	std_logic);
END component;

type nr_stages_type is array (32 downto 3) of integer;
constant nr_stages : nr_stages_type := (9, 9, 9, 8, 8, 8, 8, 8, 8, 8, 8, 8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 5, 5, 4, 3, 3);
constant stages: integer := nr_stages(nrargs); 					
constant max_sum_size: integer := sizeof(nrargs * (2**width - 1));

type cell_type is array (max_sum_size downto 0, nrargs - 1 downto 0) of std_logic;
type W_type is array (stages - 1 downto 0) of cell_type; 

signal W : W_type := (others => (others => (others => '0')));
signal add_a, add_b, add_sum : std_logic_vector(max_sum_size - 1 downto 0);

BEGIN

--	wallace_proc: process(x, W)
--		variable this_carry_bits : natural;
--		variable this_stage_bits : natural; 
--		variable num_full_adds : natural;   
--		variable num_half_adds : natural;   
--		variable num_wires : natural;   
--	begin
--		for k in 0 to stages - 2 loop
--			for i in max_sum_size - 1 downto 0 loop 
--				this_carry_bits := prev_lvl_carry_rect(nrargs, width, i, k + 1);
--				num_full_adds := num_full_adders_rect(nrargs, width, i, k);
--				for j in 0 to num_full_adds - 1 loop
--					W(k + 1)(i, this_carry_bits + j) <=  W(k)(i, j*3) xor W(k)(i, j*3 + 1) xor W(k)(i, j*3 + 2);
--					W(k + 1)(i + 1, j) <= (W(k)(i, j*3) and W(k)(i, j*3+1)) or (W(k)(i, j*3) and W(k)(i, j*3+2))or(W(k)(i, j*3+1) and W(k)(i, j*3+2));
--				end loop;
--				
--				num_half_adds := num_half_adders_rect(nrargs, width, i, k); 
--				
--				for j in 0 to num_half_adds - 1 loop
--					W(k + 1)(i, this_carry_bits + num_full_adds + j) <= W(k)(i, j*2 + num_full_adds*3) xor W(k)(i, j*2 + num_full_adds*3 + 1);
--					W(k + 1)(i+1,num_full_adds+j) <= W(k)(i, j*2+num_full_adds*3) and W(k)(i, j*2+num_full_adds*3+1);
--				end loop;
--		
--				this_stage_bits := this_lvl_bits_rect(nrargs, width, i, k); 		
--				num_wires := this_stage_bits - num_full_adds*3 - num_half_adds*2; 	
--				
--				for j in 0 to (num_wires - 1) loop
--					W(k+1)( i, this_carry_bits + num_full_adds + num_half_adds + j) <= W(k)(i, j + num_full_adds*3 + num_half_adds*2);
--				end loop;
--			end loop;
--		
--		end loop;
--	
--	end process;
	
final_stage_sum_proc: process(W) 
begin
	for i in 0 to (max_sum_size - 1) loop
		add_a(i) <= W(stages - 1)( i, 0);
		add_b(i) <= W(stages - 1)( i, 1);
	end loop;
end process;

U0: cla_add_n_bit generic map(max_sum_size) port map ('0', add_a, add_b, add_sum);
sum <= add_sum;

END Wallace_unsigned_addition;




















