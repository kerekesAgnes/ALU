----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/28/2021 04:53:27 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( op : in STD_LOGIC_VECTOR (2 downto 0);
       nr1 : in STD_LOGIC_VECTOR (15 downto 0);
       nr2 : in STD_LOGIC_VECTOR (15 downto 0);
       ALUres : out STD_LOGIC_VECTOR (15 downto 0));
end ALU;

architecture Behavioral of ALU is
signal res : STD_LOGIC_VECTOR(15 downto 0);

begin

process (op)
begin
    case op is
        when "000" => res <= nr1 + nr2;
        when "001" => res <= nr1 - nr2;
        when "010" => res <= nr1(14 downto 0) & "0";
        when "011" => res <= "0" & nr1(15 downto 1);
        when "100" => res <= not nr1;
        when "101" => res <= nr1 and nr2;
        when "110" => res <= nr1 or nr2;
        when "111" => res <= nr1 xor nr2;
        when others => res <= "0000000000000000";
    end case;
end process;

ALURes <= res;

end Behavioral;
