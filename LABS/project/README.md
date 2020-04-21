# Projekt: Vlastní ALU (Arithmetic Logic Unit)
### Zadání:
Možnost výběru instrukcí a vstupních hodnot za chodu aplikace. Výstup na 7segmentovém displeji.

### Schéma:
![Schéma ALU](ALU_schematic.png)
   
### Kód: 
ALU obsahuje 4 bloky:   
* ALU_block
* split_dig_block
* clock_enable_block
* hex_to_7seg_block

#### ALU:
ALU blok se stará o výpočety a logické operace. Má 2 vstupní 4 bitové registry A,B, 6 bitový registr Sel pro výběr operací a 8 bitový výstupní registr result.

#### Split_dig:
Tento blok má na starosti rozdělení výsledku na jednotlivé číslice (stovky, desítky, jednotky) a jejich výpis na displej. Obsahuje 1 vstupní registr result a příznak log_op, který blok informuje o tom, zda-li probíhala logická operace jako AND nebo OR. 




Dont read me yet
