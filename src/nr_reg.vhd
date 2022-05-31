----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/29/2021 05:27:31 PM
-- Design Name: 
-- Module Name: nr_reg - Behavioral
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

entity nr_reg is
    Port ( clk : in STD_LOGIC;
           right_btn : in STD_LOGIC;
           left_btn : in STD_LOGIC;
           up_btn : in STD_LOGIC;
           down_btn : in STD_LOGIC;
           enable : in STD_LOGIC;
           nr : out STD_LOGIC_VECTOR (15 downto 0));
end nr_reg;

architecture Behavioral of nr_reg is
signal digit_count : STD_LOGIC_VECTOR (1 downto 0) := "00";
signal digit_enable : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal digit0 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal digit1 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal digit2 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal digit3 : STD_LOGIC_VECTOR (3 downto 0) := "0000";

begin

digit_counter: process(clk)
begin
    if rising_edge(clk) then
        if enable = '1' then
            if left_btn='1' then
                digit_count <= digit_count + 1;
            elsif right_btn='1' then
                digit_count <= digit_count - 1;
            end if;
        end if;
    end if;
end process;

demux: process(enable, digit_count)
begin
   if enable='1' then
       case digit_count is
           when "00" => digit_enable <= "0001";
           when "01" => digit_enable <= "0010";
           when "10" => digit_enable <= "0100";
           when "11" => digit_enable <= "1000";
           when others => digit_enable <= "0000";
        end case;
    else 
        digit_enable <= "0000";
    end if;    
end process;

digit_counter_reg1: entity WORK.digit_counter port map (
                    clk => clk,
                    digit_enable => digit_enable(0),
                    up_btn => up_btn,
                    down_btn => down_btn,
                    digit => digit0
);

digit_counter_reg2: entity WORK.digit_counter port map (
                    clk => clk,
                    digit_enable => digit_enable(1),
                    up_btn => up_btn,
                    down_btn => down_btn,
                    digit => digit1
);

digit_counter_reg3: entity WORK.digit_counter port map (
                    clk => clk,
                    digit_enable => digit_enable(2),
                    up_btn => up_btn,
                    down_btn => down_btn,
                    digit => digit2
);

digit_counter_reg4: entity WORK.digit_counter port map (
                    clk => clk,
                    digit_enable => digit_enable(3),
                    up_btn => up_btn,
                    down_btn => down_btn,
                    digit => digit3
);

nr <= digit3 & digit2 & digit1 & digit0;

end Behavioral;
