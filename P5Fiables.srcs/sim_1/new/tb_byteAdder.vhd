library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_byteAdder is 
end tb_byteAdder;

architecture Testbench of tb_byteAdder is
    -- Inputs
    signal A     : std_logic_vector (7 downto 0) := (others => '0'); 
    signal B     : std_logic_vector (7 downto 0) := (others => '0');
    -- Outputs
    signal S     : std_logic_vector (7 downto 0);
    signal C_out : std_logic;
    -- Constants
    constant delay : time := 10 ns; 
    
    component byteAdder is
        port(   A       : in    std_logic_vector (7 downto 0);
                B       : in    std_logic_vector (7 downto 0);
                S       : out   std_logic_vector (7 downto 0);
                C_out   : out   std_logic
        );
    end component;
    
begin
    UUT: component byteAdder
    port map(
        A       => A,        
        B       => B,
        S       => S,
        C_out   => C_out
    );
    
    stimulus: process
    begin
        -- Prueba 1: Suma básica sin acarreo (42 + 17 = 59)
        wait for delay;
        A <= std_logic_vector(to_unsigned(42, 8));
        B <= std_logic_vector(to_unsigned(17, 8));
        wait for 1 ns; -- Pequeña espera para estabilización
        assert (S = std_logic_vector(to_unsigned(59,8))) 
          report "Error Prueba 1: Suma incorrecta (42 + 17)" 
          severity error;
        assert (C_out = '0')
          report "Error Prueba 1: C_out debería ser 0" 
          severity error;
        
        -- Prueba 2: Suma que produce acarreo (200 + 100 = 300, S=44, C_out=1)
        wait for delay;
        A <= std_logic_vector(to_unsigned(200,8));
        B <= std_logic_vector(to_unsigned(100,8));
        wait for 1 ns;
        assert (S = std_logic_vector(to_unsigned(44, 8))) 
          report "Error Prueba 2: Suma incorrecta (200 + 100)" 
          severity error;
        assert (C_out = '1')
          report "Error Prueba 2: C_out debería ser 1" 
          severity error;
        
        -- Prueba 3: Suma máxima sin acarreo (255 + 0 = 255)
        wait for delay;
        A <= std_logic_vector(to_unsigned(255, 8));
        B <= std_logic_vector(to_unsigned(0, 8));
        wait for 1 ns;
        assert (S = std_logic_vector(to_unsigned(255, 8))) 
          report "Error Prueba 3: Suma incorrecta (255 + 0)" 
          severity error;
        assert (C_out = '0')
          report "Error Prueba 3: C_out debería ser 0" 
          severity error;
        
        -- Prueba 4: Suma con acarreo en bit más bajo (128 + 128 = 256, S=0, C_out=1)
        wait for delay;
        A <= std_logic_vector(to_unsigned(128, 8));
        B <= std_logic_vector(to_unsigned(128, 8));
        wait for 1 ns;
        assert (S = std_logic_vector(to_unsigned(0, 8))) 
          report "Error Prueba 4: Suma incorrecta (128 + 128)" 
          severity error;
        assert (C_out = '1')
          report "Error Prueba 4: C_out debería ser 1" 
          severity error;
        
        -- Prueba 5: Suma con acarreo intermedio (15 + 241 = 256, S=0, C_out=1)
        wait for delay;
        A <= std_logic_vector(to_unsigned(15, 8));
        B <= std_logic_vector(to_unsigned(241, 8));
        wait for 1 ns;
        assert (S = std_logic_vector(to_unsigned(0, 8))) 
          report "Error Prueba 5: Suma incorrecta (15 + 241)" 
          severity error;
        assert (C_out = '1')
          report "Error Prueba 5: C_out debería ser 1" 
          severity error;
        
        -- Prueba 6: Suma con propagación de acarreo (255 + 1 = 256, S=0, C_out=1)
        wait for delay;
        A <= std_logic_vector(to_unsigned(255, 8));
        B <= std_logic_vector(to_unsigned(1, 8));
        wait for 1 ns;
        assert (S = std_logic_vector(to_unsigned(0, 8))) 
          report "Error Prueba 6: Suma incorrecta (255 + 1)" 
          severity error;
        assert (C_out = '1')
          report "Error Prueba 6: C_out debería ser 1" 
          severity error;
        
        wait;
    end process;
end Testbench;