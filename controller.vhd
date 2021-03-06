library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity controller is
port(
datain,clkin,fclk,rst_in: in std_logic;
clk_v: in std_logic;
vXout, vYout: out std_logic_vector(2 downto 0);
mX, mY: out std_logic
);
end controller;

architecture behave of controller is

component Keyboard is
port (
	datain, clkin : in std_logic ; -- PS2 clk and data
	fclk, rst : in std_logic ;  -- filter clock
	key : out std_logic_vector(3 downto 0)
	) ;
end component;

signal rst : std_logic;
signal accXp, accYp, accXm, accYm: std_logic;
signal vX, vY : integer range -10 to 10 := 0;
signal key: std_logic_vector(3 downto 0);

begin
	rst<=not rst_in;

	u0: Keyboard port map(datain,clkin,fclk,rst,key);
	
	accYp <= key(1);
	accXp <= key(3);
	
	accYm <= key(0);
	accXm <= key(2);
	
	V : process(clk_v, rst_in)
    begin
        if (rst_in = '0') then
            vX <= 0;
            vY <= 0;
        elsif (clk_v'event and clk_v = '1') then
			vX <= vX + conv_integer(accXp) - conv_integer(accXm);
            if (vX > 6) then
                vX <= 6;
            elsif (vX < -6) then
                vX <= -6;
            end if;
            vY <= vY + conv_integer(accYp) - conv_integer(accYm);
            if (vY > 6) then
                vY <= 6;
            elsif (vY < -6) then
                vY <= -6;
            end if;
            if (vX < 0) then
				mX <= '1';
				vXout <= conv_std_logic_vector(0 - vX, 3);
			else
				mX <= '0';
				vXout <= conv_std_logic_vector(vX, 3);
			end if;
			if (vY < 0) then
				mY <= '1';
				vYout <= conv_std_logic_vector(0 - vY, 3);
			else
				mY <= '0';
				vYout <= conv_std_logic_vector(vY, 3);
			end if;

        end if;
    end process;

end behave;
