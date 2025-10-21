<?php

class ConexionDB
{
    public static function setConnection()
    {
        $host = "localhost";
        $dbName = 'PAPELERIAELTRIUNFO';
        $user = 'root';
        $password = 'mariadebe';
        $port = '3306';
        $characterSet = 'utf8mb4';

        $dsn = "mysql:host=$host;dbname=$dbName;port=$port;charset=$characterSet";
        $options = [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ];

        try {
            return new PDO($dsn, $user, $password, $options);
        } catch (PDOException $e) {
            throw new PDOException('Error de conexion: ' . $e->getMessage());
        }
    }
}

?>