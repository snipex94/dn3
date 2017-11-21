LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE Wallace_tree_functions IS

	--	@Type name: sizeof
	-- @Parameters:
	--	argument 1: x dimenzija polja
	--	argument 2: y dimenzija polja 
	--	@Description:
	--	definicija tipa splošnega dvodimenzionalnega polja (x, y) bitov tipa STD_LOGIC
	Type ArrayOfAddends is array (natural range <>, natural range <>) of STD_LOGIC;

	--	@Function name: sizeof
	-- @Parameters:
	--	a: vhodno število
	--	@Return:
	--	Vrne število bitov, potrebnih za zapis števila a
	FUNCTION sizeof (a: NATURAL) RETURN NATURAL;	--
	
	--	@Function name: prev_lvl_carry_rect
	-- @Parameters:
	--	height: višina Wallaceove drevesne strukture na danem nivoju redukcije
	--	arg_width: velikost operanda Wallaceove drevesne strukture na danem nivoju redukcije
	--	this_weight: Utež (stolpec) Wallaceove drevesne strukture na danem nivoju redukcije
	--	this_lvl: nivo redukcije Wallaceove drevesne strukture
	--	@Return:
	--	Število bitov prenosa za dani stolpec podanega nivoja redukcije Wallaceove drevesne strukture (this_lvl)
	FUNCTION prev_lvl_carry_rect (height: NATURAL; arg_width: NATURAL; this_weight: NATURAL; this_lvl: NATURAL) RETURN NATURAL;
	
	--	@Function name: this_lvl_bits_rect
	-- @Parameters:
	--	height: višina Wallaceove drevesne strukture na danem nivoju redukcije
	--	arg_width: velikost operanda Wallaceove drevesne strukture na danem nivoju redukcije
	--	this_weight: Utež (stolpec) Wallaceove drevesne strukture na danem nivoju redukcije
	--	this_lvl: nivo redukcije Wallaceove drevesne strukture
	--	@Return:
	--	Število bitov v danem stolpcu podanega nivoja redukcije Wallaceove drevesne strukture (this_lvl)
	FUNCTION this_lvl_bits_rect (height: NATURAL; arg_width: NATURAL; this_weight: NATURAL; this_lvl: NATURAL) RETURN NATURAL;
	
	--	@Function name: num_full_adders_rect
	-- @Parameters:
	--	height: višina Wallaceove drevesne strukture na danem nivoju redukcije
	--	arg_width: velikost operanda Wallaceove drevesne strukture na danem nivoju redukcije
	--	this_weight: Utež (stolpec) Wallaceove drevesne strukture na danem nivoju redukcije
	--	this_lvl: nivo redukcije Wallaceove drevesne strukture
	--	@Return:
	--	Število polnih seštevalnikov v danem stolpcu podanega nivoja redukcije Wallaceove drevesne strukture (this_lvl)
	FUNCTION num_full_adders_rect (height: NATURAL; arg_width: NATURAL; this_weight: NATURAL; this_lvl: NATURAL) RETURN NATURAL;
	
	--	@Function name: num_half_adders_rect
	-- @Parameters:
	--	height: višina Wallaceove drevesne strukture na danem nivoju redukcije
	--	arg_width: velikost operanda Wallaceove drevesne strukture na danem nivoju redukcije
	--	this_weight: Utež (stolpec) Wallaceove drevesne strukture na danem nivoju redukcije
	--	this_lvl: nivo redukcije Wallaceove drevesne strukture
	--	@Return:
	--	Število polnih seštevalnikov v danem stolpcu podanega nivoja redukcije Wallaceove drevesne strukture (this_lvl)
	FUNCTION num_half_adders_rect (height: NATURAL; arg_width: NATURAL; this_weight: NATURAL; this_lvl: NATURAL) RETURN NATURAL;
	
END Wallace_tree_functions;

PACKAGE BODY Wallace_tree_functions IS
------------------------------------------------------------------------------------------------------------------		
	FUNCTION sizeof (a: NATURAL) RETURN NATURAL is
		variable nr : natural := a;
		variable n : natural;
	begin
		for n in 0 to a loop
			nr := nr / 2;
			exit when nr = 0;
		end loop;
		return n;
	end sizeof;
------------------------------------------------------------------------------------------------------------------		
	FUNCTION prev_lvl_carry_rect (height: NATURAL; arg_width: NATURAL; this_weight: NATURAL; this_lvl: NATURAL) RETURN NATURAL is
		variable num_carry : natural;
		variable prev_lvl_bits : natural;
	begin
		if this_weight = 0 then
			num_carry := 0;
		elsif this_lvl = 0 then
			num_carry := height / 3;
			prev_lvl_bits := height - (num_carry) * 3;
			num_carry := num_carry + prev_lvl_bits / 2;
		else
			prev_lvl_bits := this_lvl_bits_rect(height, arg_width, this_weight, this_lvl - 1);
			num_carry := prev_lvl_bits / 3;
			prev_lvl_bits := prev_lvl_bits - (num_carry) * 3;
			num_carry := num_carry + (prev_lvl_bits / 2);
		end if;
			
		return num_carry;
	end prev_lvl_carry_rect;
------------------------------------------------------------------------------------------------------------------		
	FUNCTION this_lvl_bits_rect (height: NATURAL; arg_width: NATURAL; this_weight: NATURAL; this_lvl: NATURAL) RETURN NATURAL is
		variable prev_lvl_bits : natural;
		variable full_adder_sum_bits : natural;
		variable half_adder_sum_bits : natural;
		variable this_num_bits : natural;
	begin
		if this_lvl = 0 then
			this_num_bits := height;
		else
			prev_lvl_bits := this_lvl_bits_rect(height, arg_width, this_weight, this_lvl - 1);
		end if;
		
		full_adder_sum_bits := prev_lvl_bits / 3;
		half_adder_sum_bits := (prev_lvl_bits - (full_adder_sum_bits * 3)) / 2;
		this_num_bits := (prev_lvl_bits - (full_adder_sum_bits * 3) - (half_adder_sum_bits * 2)) + full_adder_sum_bits + half_adder_sum_bits + prev_lvl_carry_rect(height, arg_width, this_weight, this_lvl);
		
		return this_num_bits;
	end this_lvl_bits_rect;
------------------------------------------------------------------------------------------------------------------		
	FUNCTION num_full_adders_rect (height: NATURAL; arg_width: NATURAL; this_weight: NATURAL; this_lvl: NATURAL) RETURN NATURAL is
	begin
		return (this_lvl_bits_rect(height, arg_width, this_weight, this_lvl)) / 3;
	end num_full_adders_rect;
------------------------------------------------------------------------------------------------------------------	
	FUNCTION num_half_adders_rect (height: NATURAL; arg_width: NATURAL; this_weight: NATURAL; this_lvl: NATURAL) RETURN NATURAL is
		variable this_num_bits : natural;
		variable num_full_adds : natural;
	begin
		this_num_bits := this_lvl_bits_rect(height, arg_width, this_weight, this_lvl);
		num_full_adds := (this_num_bits - (this_num_bits / 3)) / 2;
		return num_full_adds;
	end num_half_adders_rect;
------------------------------------------------------------------------------------------------------------------		
END Wallace_tree_functions;
