#!/bin/bash

# Компиляция
nasm -f elf32 425.asm -o 425.o

# Линковка с опцией для 32-битной архитектуры
gcc -m32 425.o -o 425
    

echo "Сборка завершена. Для запуска программы выполните: ./425"
