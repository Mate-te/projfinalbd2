CREATE VIEW Emprestimos_ativos AS
SELECT 
    e.id_emp,
    c.Nome AS Cliente,
    b.Nome_bibli AS Bibliotecario,
    l.Titulo AS Livro,
    e.inicio,
    e.fim
FROM 
    Emprestimo e
JOIN 
    Cliente c ON e.Cli = c.id_cliente
JOIN 
    Bibliotecario b ON e.Bibli = b.id_bibli
JOIN 
    Livro l ON e.Liv = l.id_livro
WHERE 
    e.ativo = true;



create view Historico_emprestimos as
select 
    c.Nome as Cliente,
    l.Titulo as Livro,
    e.inicio,
    e.fim,
    case when e.ativo = true then 'Ativo' else 'Concluído' end as Status
from 
    Emprestimo e
join 
    Cliente c on e.Cli = c.id_cliente
join 
    Livro l on e.Liv = l.id_livro;



CREATE VIEW Livros_populares AS
SELECT 
    l.Titulo,
    l.Categoria,
    a.Nome AS Autor,
    COUNT(e.id_emp) AS NumeroEmprestimos
FROM 
    Livro l
JOIN 
    Emprestimo e ON l.id_livro = e.Liv
JOIN 
    Autor a ON l.autorL = a.id_autor
GROUP BY 
    l.Titulo, l.Categoria, a.Nome
ORDER BY 
    NumeroEmprestimos DESC;
