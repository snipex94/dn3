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
	
	FUNCTION sizeof (a: NATURAL) RETURN NATURAL is	--
		variable nr : natural := a;
	begin
		for a in 0 to 32 loop
			nr := nr / 2;
			exit when nr = 0;
		end loop;
		return a;
	end sizeof;
	
	FUNCTION this_lvl_bits_rect (height: NATURAL; arg_width: NATURAL; this_weight: NATURAL; this_lvl: NATURAL) RETURN NATURAL is
	begin
		
	end this_lvl_bits_rect;
	
END Wallace_tree_functions;
