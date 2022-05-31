----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/29/2021 03:27:42 PM
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end main;

architecture Behavioral of main is
--buttons
signal middle_btn : STD_lOGIC := '0';
signal up_btn : STD_lOGIC := '0';
signal down_btn : STD_lOGIC := '0';
signal left_btn : STD_lOGIC := '0';
signal right_btn : STD_lOGIC := '0';

signal op_count : STD_LOGIC_VECTOR (2 downto 0) := "000";

-- control signals
signal read_operation : STD_lOGIC := '0';
signal read_nr1_enable : STD_lOGIC := '0';
signal read_nr2_enable : STD_lOGIC := '0';

signal nr1 : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
signal nr2 : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";

signal ALUres : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";

signal digit0 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal digit1 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal digit2 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal digit3 : STD_LOGIC_VECTOR (3 downto 0) := "0000";

signal r_digit0 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal r_digit1 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal r_digit2 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal r_digit3 : STD_LOGIC_VECTOR (3 downto 0) := "0000";

type TYPE_STATE is (read_nr1, read_nr2, operation, result);
signal state: TYPE_STATE := read_nr1;

begin

mpg_m: entity WORK.MPG port map (
        btn => btn(0),
        clk => clk,
        enable => middle_btn
);

mpg_u: entity WORK.MPG port map (
        btn => btn(1),
        clk => clk,
        enable => up_btn
);

mpg_d: entity WORK.MPG port map (
        btn => btn(4),
        clk => clk,
        enable => down_btn
);

mpg_l: entity WORK.MPG port map (
        btn => btn(2),
        clk => clk,
        enable => left_btn
);

mpg_r: entity WORK.MPG port map (
        btn => btn(3),
        clk => clk,
        enable => right_btn
);


op_counter: process(clk)
begin
    if rising_edge(clk) then
        if read_operation = '1' then
            if up_btn='1' then
                op_count <= op_count + 1;
            elsif down_btn='1' then
                op_count <= op_count - 1;
            end if;
        end if;
    end if;
end process;

nr1_reg: entity WORK.nr_reg port map (
                    clk => clk,
                    right_btn => right_btn,
                    left_btn => left_btn,
                    up_btn => up_btn,
                    down_btn => down_btn,
                    enable => read_nr1_enable,
                    nr => nr1
);

nr2_reg: entity WORK.nr_reg port map (
                    clk => clk,
                    right_btn => right_btn,
                    left_btn => left_btn,
                    up_btn => up_btn,
                    down_btn => down_btn,
                    enable => read_nr2_enable,
                    nr => nr2
);

alu_i: entity WORK.ALU port map (
                    op => op_count,
                    nr1 => nr1,
                    nr2 => nr2,
                    ALUres => ALUres
);

ssd_mux: process(state)
begin
    case state is
        when read_nr1 => digit0 <= nr1(3 downto 0);
                         digit1 <= nr1(7 downto 4);
                         digit2 <= nr1(11 downto 8);
                         digit3 <= nr1(15 downto 12);
        when read_nr2 => digit0 <= nr2(3 downto 0);
                         digit1 <= nr2(7 downto 4);
                         digit2 <= nr2(11 downto 8);
                         digit3 <= nr2(15 downto 12);
        when operation => digit0 <= "0" & op_count;
                          digit1 <= "0000";
                          digit2 <= "0000";
                          digit3 <= "0000";
        when result => digit0 <= ALUres(3 downto 0);
                       digit1 <= ALUres(7 downto 4);
                       digit2 <= ALUres(11 downto 8);
                       digit3 <= ALUres(15 downto 12);
       when others => digit0 <= "0000";
                      digit1 <= "0000";
                      digit2 <= "0000";
                      digit3 <= "0000";
    end case;      
end process;

ssd_i: entity WORK.SSD port map (
                        digit0 => digit0,
                        digit1 => digit1,
                        digit2 => digit2,
                        digit3 => digit3,
                        clk => clk,
                        an => an,
                        cat => cat
);


control: process(state)
begin
    case state is
        when read_nr1 => read_nr1_enable <= '1';
                         read_nr2_enable <= '0';
                         read_operation <= '0';
        when read_nr2 => read_nr2_enable <= '1';
                         read_nr1_enable <= '0';
                         read_operation <= '0';
        when operation => read_operation <= '1';
                         read_nr2_enable <= '0';
                         read_nr1_enable <= '0';
        when others => read_nr1_enable <= '0';
                       read_nr2_enable <= '0';
                       read_operation <= '0';
    end case;
end process;

control2: process(clk, state, middle_btn)
begin
    if rising_edge(clk) then
        case state is
            when read_nr1 => 
                    if middle_btn='1' then
                        state <= read_nr2;
                    end if;
            when read_nr2 => 
                     if middle_btn='1' then
                        state <= operation;
                     end if;
            when operation =>
                      if middle_btn='1' then
                        state <= result;
                      end if;
            when result =>
                        if middle_btn='1' then
                            state <= read_nr1;
                        end if;
            when others => state <= read_nr1;
        end case;
    end if;              
end process;

end Behavioral;
