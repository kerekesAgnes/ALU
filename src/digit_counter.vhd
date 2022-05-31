----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/29/2021 05:43:00 PM
-- Design Name: 
-- Module Name: digit_counter - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity digit_counter is
    Port ( clk : in STD_LOGIC;
           digit_enable : in STD_LOGIC;
           up_btn : in STD_LOGIC;
           down_btn : in STD_LOGIC;
           digit : out STD_LOGIC_VECTOR (3 downto 0));
end digit_counter;

architecture Behavioral of digit_counter is
signal digit_count : STD_LOGIC_VECTOR (3 downto 0) := "0000";

begin
process(clk)
begin
    if rising_edge(clk) then
        if digit_enable = '1' then
            if up_btn='1' then
                digit_count <= digit_count + 1;
            elsif down_btn='1' then
                digit_count <= digit_count - 1;
            end if;
        end if;
    end if;
end process;

digit <= digit_count;

end Behavioral;
