#!/usr/bin/env bash
set -e

echo ">>> Установка Go-зависимостей..."
go mod tidy

echo ">>> Проверка подключения к PostgresSQL..."
psql "host=localhost port=5432 dbname=project-sem-1 user=validator password=val1dat0r" -c "SELECT now();"

echo ">>> БД доступна. Создание таблицы (если не существует)..."
psql "host=localhost port=5432 dbname=project-sem-1 user=validator password=val1dat0r" <<EOF
CREATE TABLE IF NOT EXISTS prices (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    price NUMERIC NOT NULL,
    create_date DATE NOT NULL
);
EOF
echo ">>> Скрипт подготовки успешно выполнен"