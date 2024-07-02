--funcaod e emprestimo
CREATE OR REPLACE FUNCTION Empresta(id_cliente int ,id_bibli int ,id_livro int)
RETURNS boolean as $$
BEGIN
	--insere os os ids de cliente livro e bibliotecario, mais a data atual e 30 dias pra frente
    INSERT INTO Emprestimo(cli,bibli,liv,inicio,fim,ativo) 
    VALUES (id_cliente,id_bibli,id_livro,CURRENT_DATE,CURRENT_DATE+30,true);
    return true;
end;
$$ language plpgsql;

--funcao que mostra qnt de livros disponiveis
CREATE OR REPLACE FUNCTION Livros_disp(id_l int)
RETURNS INT AS $$
DECLARE
	disp int; --variavel para a conta
BEGIN
	disp = (SELECT qnt_total from Livro where id_livro = id_l) - (SELECT qnt_emprestados from Livro where id_livro = id_l); --diferenca entre livros disponiveis e alugados (disponiveis)
	return disp;
end;
$$ language plpgsql;

--funcao que mostra os livros de um autor
create or replace function Livros_autor (id_aut int) 
	--tabela que ira retornar os livros do autor
returns table (
	idlivro int,
	Titulo_livro varchar
) 
language plpgsql
as $$
begin
	return query
	--escolhe o id e o titulo dos livros do autor de id fornecido
		select
			id_livro,
			Titulo
		from
			Livro
		where
			id_aut=livro.autorL;
end;
$$;
