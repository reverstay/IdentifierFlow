-- Criar banco de dados
CREATE DATABASE "arvore";

-- Usar o banco de dados
\c "arvore";

-- Criar tabela Usuarios
CREATE TABLE "Usuarios" (
                            "id" serial PRIMARY KEY,
                            "idUser" char(14) NOT NULL,
                            "Nome" varchar(100) NOT NULL,
                            "email" varchar(50) NOT NULL,
                            "quantidade" int NOT NULL
);

-- Criar tabela Links
CREATE TABLE "Links" (
                         "id" serial PRIMARY KEY,
                         "Nome" varchar(100) NOT NULL,
                         "Telefone" varchar(20) NOT NULL,
                         "IdUsuario" int NOT NULL,
                         CONSTRAINT "FK_Links_Usuarios" FOREIGN KEY ("IdUsuario") REFERENCES "Usuarios"("id")
);
