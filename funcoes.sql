CREATE OR REPLACE FUNCTION Empresta(id_cliente int ,id_bibli int ,id_livro int)
RETURNS boolean as $$
BEGIN
    INSERT INTO Emprestimo(cli,bibli,liv,inicio,fim,ativo) 
    VALUES (id_cliente,id_bibli,id_livro,CURRENT_DATE,CURRENT_DATE+30,true);
    return true;
end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION Livros_disp(id_l int)
RETURNS INT AS $$
DECLARE
	disp int;
BEGIN
	disp = (SELECT qnt_total from Livro where id_livro = id_l) - (SELECT qnt_emprestados from Livro where id_livro = id_l);
	return disp;
end;
$$ language plpgsql;

create or replace function Livros_autor (id_aut int) 
returns table (
	idlivro int,
	Titulo_livro varchar
) 
language plpgsql
as $$
begin
	return query 
		select
			id_livro,
			Titulo
		from
			Livro
		where
			id_aut=livro.autorL;
end;
$$;
