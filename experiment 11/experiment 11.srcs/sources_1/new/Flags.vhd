----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2017 12:11:21 PM
-- Design Name: 
-- Module Name: Flags - Behavioral
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

entity Flags is
    Port ( FLG_C_SET : in STD_LOGIC;
           FLG_C_CLR : in STD_LOGIC;
           FLG_C_LD : in STD_LOGIC;
           FLG_Z_LD : in STD_LOGIC;
           FLG_LD_SEL : in STD_LOGIC;
           FLG_SHAD_LD : in STD_LOGIC;
           C_FLAG : out STD_LOGIC;
           Z_FLAG : out STD_LOGIC;
           C : in STD_LOGIC;
           Z : in STD_LOGIC;
           CLK : in STD_LOGIC);
end Flags;

architecture Behavioral of Flags is

    component FlagReg is 
        port ( D    : in  STD_LOGIC; --flag input
               LD   : in  STD_LOGIC; --load Q with the D value
               SET  : in  STD_LOGIC; --set the flag to '1'
               CLR  : in  STD_LOGIC; --clear the flag to '0'
               CLK  : in  STD_LOGIC; --system clock
               Q    : out  STD_LOGIC); --flag output
    end component;
    
    component Mux_2x1_1bit is
        Port ( A : in STD_LOGIC;
               B : in STD_LOGIC;
               SEL : in STD_LOGIC;
               OUTPUT : out STD_LOGIC);
    end component;


    signal z_shad : std_logic; 
    signal c_shad : std_logic;
    signal z_out : std_logic;
    signal c_out : std_logic;
    signal c_mux_out : std_logic;
    signal z_mux_out : std_logic;

begin

    C_FLAG <= c_out;
    Z_FLAG <= z_out;
    
    my_cFlag : FlagReg
        port map ( D   => c_mux_out,
                   LD  => FLG_C_LD,
                  SET  => FLG_C_SET,
                  CLR  => FLG_C_CLR,
                  CLK  => CLK,
                   Q   => c_out);

    my_ZFlag : FlagReg
        port map ( D   => z_mux_out,
                   LD  => FLG_Z_LD,
                  SET  => '0',
                  CLR  => '0',
                  CLK  => CLK,
                   Q   => z_out);                   

    my_shad_z : FlagReg
        port map ( D   => z_out,
                   LD  => FLG_SHAD_LD,
                  SET  => '0',
                  CLR  => '0',
                  CLK  => CLK,
                   Q   => z_shad);
                   
    my_shad_c : FlagReg
        port map ( D   => c_out,
                   LD  => FLG_SHAD_LD,
                  SET  => '0',
                  CLR  => '0',
                  CLK  => CLK,
                   Q   => c_shad);
                   
    c_flag_mux : Mux_2x1_1bit
        Port map ( A => C,
                   B => c_shad,
                   SEL => FLG_LD_SEL,
                   OUTPUT => c_mux_out);

    z_flag_mux : Mux_2x1_1bit
        Port map ( A => Z,
                   B => z_shad,
                   SEL => FLG_LD_SEL,
                   OUTPUT => z_mux_out);
                   
end Behavioral;
