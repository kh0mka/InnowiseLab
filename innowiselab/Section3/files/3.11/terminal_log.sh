#!/bin/bash

# Указываем путь для сохранения лога
log_directory="/home/khomenok"

# Установим дату и время для имени файла
filename="${log_directory}/terminal_log_$(date +%Y%m%d_%H%M%S).log"

# Запускаем запись сессии в файл
script "$filename"

# Возвращаем код завершения команды script
exit $?
