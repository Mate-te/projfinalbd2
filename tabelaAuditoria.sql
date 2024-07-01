CREATE TABLE Auditoria (
    tabela TEXT not null,
    usuario TEXT,
    data timestamp with time zone not null default current_timestamp,
    acao TEXT NOT NULL check (acao in ('I','D','U')),
    dado_original TEXT,
    dado_novo TEXT,
    query TEXT
);

REVOKE all ON Auditoria FROM public;


CREATE OR REPLACE FUNCTION Funcao_auditoria() RETURNS trigger AS $body$
DECLARE
    dado_old TEXT;
    dado_new TEXT;
BEGIN

    if (TG_OP = 'UPDATE') then
        dado_old := ROW(OLD.*);
        dado_new := ROW(NEW.*);
        INSERT INTO Auditoria (tabela, usuario, acao, dado_original, dado_novo, query) 
        VALUES (TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1), dado_old, dado_new, current_query());
        RETURN NEW;
    elsif (TG_OP = 'DELETE') then
        dado_old := ROW(OLD.*);
        INSERT INTO Auditoria (tabela, usuario, acao, dado_original, query)
        VALUES (TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1), dado_old, current_query());
        RETURN OLD;
    elsif (TG_OP = 'INSERT') then
        dado_new := ROW(NEW.*);
        INSERT INTO Auditoria (tabela, usuario, acao, dado_novo, query)
        VALUES (TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1), dado_new, current_query());
        RETURN NEW;
    else
        RAISE WARNING '[IF_MODIFIED_FUNC] - Other action occurred: %, at %',TG_OP,now();
        RETURN NULL;
    end if;

END;
$body$
LANGUAGE plpgsql;

CREATE TRIGGER "trigger_cliente"
AFTER INSERT OR UPDATE OR DELETE ON Cliente
FOR EACH ROW EXECUTE PROCEDURE Funcao_auditoria();


CREATE TRIGGER "trigger_emprestimo"
AFTER INSERT OR UPDATE OR DELETE ON emprestimo
FOR EACH ROW EXECUTE PROCEDURE Funcao_auditoria();

CREATE TRIGGER "trigger_livro"
AFTER INSERT OR UPDATE OR DELETE ON livro
FOR EACH ROW EXECUTE PROCEDURE Funcao_auditoria();
