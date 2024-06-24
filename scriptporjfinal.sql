
CREATE TABLE Autor(
    id_autor int;
    Nome varchar(100);
    Biografia varchar(1000);
    CONSTRAINT pkid_autor PRIMARY KEY (id_autor);
);

CREATE TABLE Editora(
    id_editora int;
    Nome varchar(100);
    CONSTRAINT pkid_editora PRIMARY KEY (id_editora);
);

CREATE TABLE Cliente(
    id_cliente int;
    CPF varchar(14) UNIQUE;
    Nome varchar(100);
    Data_reg date;
    Numero_emp int;
    Endereco varchar(100);
    CONSTRAINT pkid_cliente PRIMARY KEY (id_cliente);
);

CREATE TABLE Bibliotecario(
    id_bibli int;
    Nome_bibli varchar(100);
    Data_ent date;
    Endereco varchar(100);
    CONSTRAINT pkid_bibli PRIMARY KEY (id_bibli);
);

CREATE TABLE Livro(
    id_livro int;
    ISBN varchar(14) UNIQUE;
    Titulo varchar(150);
    Categoria varchar(50);
    autorL int;
    editoraL int;
    CONSTRAINT pkid_livro PRIMARY KEY (id_livro);
    CONSTRAINT fkautorL FOREIGN KEY (autorL) REFERENCES Autor(id_autor);
    CONSTRAINT fkeditoraL FOREIGN KEY (editoraL) REFERENCES Editora(id_editora)

);


CREATE TABLE Emprestimo(
    id_emp int;
    Cli int;
    Bibli int;
    Liv int;
    inicio date;
    fim date;
    ativo boolean;
    CONSTRAINT pkid_emp PRIMARY KEY (id_emp);
    CONSTRAINT fkCli FOREIGN KEY (Cli) REFERENCES Cliente(id_cliente);
    CONSTRAINT fkeditoraL FOREIGN KEY (editoraL) REFERENCES Bibliotecario(id_bibli);
    CONSTRAINT fkeditoraL FOREIGN KEY (editoraL) REFERENCES Livro(id_livro);
);
