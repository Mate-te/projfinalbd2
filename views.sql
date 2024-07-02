create view Emprestimos_ativos as
select 
    e.id_emp,
    c.Nome as Cliente,
    b.Nome_bibli as Bibliotecario,
    l.Titulo as Livro,
    e.inicio,
    e.fim
from Emprestimo e
join Cliente c on e.Cli = c.id_cliente
join Bibliotecario b on e.Bibli = b.id_bibli
join Livro l on e.Liv = l.id_livro
where e.ativo = true;



create view Historico_emprestimos as
select 
    c.Nome as Cliente,
    l.Titulo as Livro,
    e.inicio,
    e.fim,
    case when e.ativo = true then 'Ativo' else 'Concluído' end as Status
from Emprestimo e
join Cliente c on e.Cli = c.id_cliente
join Livro l on e.Liv = l.id_livro;



create view Livros_populares as
select
    l.Titulo,
    l.Categoria,
    a.Nome as Autor,
    count(e.id_emp) as NumeroEmprestimos
from Livro l
join Emprestimo e on l.id_livro = e.Liv
join Autor a on l.autorL = a.id_autor
group by l.Titulo, l.Categoria, a.Nome
order by NumeroEmprestimos desc;
