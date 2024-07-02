CREATE TABLE Auditoria (
    tabela TEXT not null,
    usuario TEXT,
    data timestamp with time zone not null default current_timestamp,
    acao TEXT NOT NULL check (acao in ('I','D','U')),
    dado_original TEXT,
    dado_novo TEXT,
    query TEXT
);
--tira permissao de todos para tabela
REVOKE all ON Auditoria FROM public;


CREATE OR REPLACE FUNCTION Funcao_auditoria() RETURNS trigger AS $body$
DECLARE
    dado_old TEXT; --dado antigo
    dado_new TEXT; --dado novo
BEGIN

    if (TG_OP = 'UPDATE') then --se a operacao da trigger for um update
        dado_old := ROW(OLD.*); --guarda o dado original
        dado_new := ROW(NEW.*); --guarda o dado atualizdado
        INSERT INTO Auditoria (tabela, usuario, acao, dado_original, dado_novo, query) 
        VALUES (TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1), dado_old, dado_new, current_query());
        RETURN NEW;
    elsif (TG_OP = 'DELETE') then --se a operacao da trigger for um delete
        dado_old := ROW(OLD.*); --gurda o dado original (nao tem dado novo)
        INSERT INTO Auditoria (tabela, usuario, acao, dado_original, query)
        VALUES (TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1), dado_old, current_query());
        RETURN OLD;
    elsif (TG_OP = 'INSERT') then --se a operacao da trigger for um insert 
        dado_new := ROW(NEW.*); --guarda o dado novo (nao existe dado antigo)
        INSERT INTO Auditoria (tabela, usuario, acao, dado_novo, query)
        VALUES (TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1), dado_new, current_query());
        RETURN NEW;
    end if;

END;
$body$
LANGUAGE plpgsql;

--triggers q ativam com insert, update e delete para cliente, emprestimo e livro

CREATE TRIGGER "trigger_cliente"
AFTER INSERT OR UPDATE OR DELETE ON Cliente
FOR EACH ROW EXECUTE PROCEDURE Funcao_auditoria();


CREATE TRIGGER "trigger_emprestimo"
AFTER INSERT OR UPDATE OR DELETE ON emprestimo
FOR EACH ROW EXECUTE PROCEDURE Funcao_auditoria();

CREATE TRIGGER "trigger_livro"
AFTER INSERT OR UPDATE OR DELETE ON livro
FOR EACH ROW EXECUTE PROCEDURE Funcao_auditoria();
