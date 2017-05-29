# migration_reductor
Переезд с Carbon Reductor 7 на Carbon Reductor 8


Состоит из следюущих скриптов:

1) `migration.sh` собирает

- userinfo(конфигурационный файл, хуки и т.д.)
- lists(все списки, кроме tmp)
- reg(данные для регистрации)
- network-scripts(конфигурация сети)
- dump(переносим последний dump.xml)
- cache(сигнатуры и т.д.)
- request(файлы запроса и подпись)

2) `import.sh`
- раскладывает все по полочкам
- применяет значения из CRB7 в CRB8.
