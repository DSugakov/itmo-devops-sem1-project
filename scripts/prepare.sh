#!/usr/bin/env bash
set -e

echo ">>> Установка Go-зависимостей..."
go mod tidy || { echo "Ошибка: Не удалось установить Go-зависимости"; exit 1; }

echo ">>> Ожидание доступности PostgreSQL..."
until psql "host=localhost port=5432 dbname=project-sem-1 user=validator password=val1dat0r" -c "SELECT 1;" >/dev/null 2>&1; do
    echo "PostgreSQL пока недоступен. Повторная проверка через 2 секунды..."
    sleep 2
done
echo "PostgreSQL доступен."

echo ">>> Удаление старой таблицы (если требуется)..."
psql "host=localhost port=5432 dbname=project-sem-1 user=validator password=val1dat0r" -c "DROP TABLE IF EXISTS prices;" || {
    echo "Ошибка: Не удалось удалить таблицу";
    exit 1;
}

echo ">>> Создание таблицы..."
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
if [ $? -ne 0 ]; then
    echo "Ошибка: Не удалось создать таблицу"
    exit 1
fi

echo ">>> Скрипт подготовки успешно выполнен."