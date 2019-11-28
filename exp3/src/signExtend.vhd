-------------------------------------------------------
--! @file signExtend.vhdl
--! @author mateus.vendramini@usp.br
--! @date 2019
--! @brief 2-complement sign extension used on polileg.
-------------------------------------------------------
entity signExtend is
	-- Size of output is expected to be greater than input
	generic(
	  ws_in:  natural := 32; -- input word size
		ws_out: natural := 64); -- output word size
	port(
		i: in	 bit_vector(ws_in-1  downto 0); -- input
		o: out bit_vector(ws_out-1 downto 0)  -- output
	);
end signExtend;

architecture combinational of signExtend is
begin
--	lsb: for idx in 0 to (i'length-1) generate
--		o(idx) <= i(idx);
--	end generate;
--	msb: for idx in (i'length) to (o'length-1) generate
--		o(idx) <= i(i'length-1);
--	end generate;
process(i) 
begin
	case i (27 downto 26) is
		when "00" => --I instruction
			report "i instruction extended";
            if i(23) = '1' then --move
			report "mov";
            o(17 downto 0) <= i(22 downto 5);
            msbim: for idx in (18) to (63) loop
                o(idx) <= '0';
            end loop;
            
            else --others
			report "other imediate";
                o(11 downto 0) <= i(21 downto 10);
                msbI: for idx in (12) to (63) loop
                    o(idx) <= i(21);
                end loop msbI;
            end if;
			
			--end;
	
		when "01"=> --CB or B
			report "CB or B extended";
			if i(29) = '0' then -- B
				report "B extended";
				o(25 downto 0) <= i(25 downto 0);
				msbCB: for idx in (26) to (63) loop
					o(idx) <= i(25);
				end loop msbCB;
			else -- CBZ or CBNZ
				report "cb extended";
				o(18 downto 0) <= i(23 downto 5);
				msbCB2: for idx in (19) to (63) loop
					o(idx) <= i(23);
				end loop msbCB2;
			end if;
			
			--end;
		when "10"=> --ls
			report "ls extended";
			o(8 downto 0) <= i(20 downto 12);
			msbLS: for idx in (9) to (63) loop
				o(idx) <= i(20);
			end loop msbLS;
			
			
			--end;
		when others => o <= i & i ;
		
	end case;
	
end process;
end combinational;
