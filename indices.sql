create index idx_tituloLivro on livro(titulo);

create INDEX idx_livroautor on Livro(autorL);

create INDEX idx_emprestimoinicio on Emprestimo(inicio);
create INDEX idx_emprestimofim on Emprestimo(fim);


explain analyze select l.*
from Livro l
join Autor a on l.autorL = a.id_autor
where a.Nome like 'A%';

explain analyze select id_livro, isbn, categoria,id_autor, nome
from livro l
join autor a on a.id_autor = l.autorL
where titulo = 'man between, the'

explain analyze select * 
from emprestimo 
where inicio > '10-02-2023'
