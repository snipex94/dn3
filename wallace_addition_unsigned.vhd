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
		sum	:	OUT STD_LOGIC_VECTOR(sizeof( nrargs * ( 2**width - 1)) - 1 DOWNTO 0)	-- vsota
	);		
END wallace_addition;

ARCHITECTURE Wallace_unsigned_addition OF wallace_addition IS
BEGIN
END Wallace_unsigned_addition;