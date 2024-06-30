-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< TRIGGERS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE OR REPLACE FUNCTION alteraDiponivelLivro()
RETURNS TRIGGER AS $$
DECLARE
	livroid int;
	clienteid int;
BEGIN
	select liv,cli
	into livroid, clienteid
    from Emprestimo
    where id_emp = NEW.id_emp; 


    UPDATE Livro
	SET qnt_emprestimo = qnt_emprestimo + 1
	WHERE id_livro = livroid;

	UPDATE Cliente
	SET Numero_emp = Numero_emp + 1
	WHERE id_cliente = clienteid;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_alteraDiponivelLivro
AFTER INSERT OR UPDATE ON Emprestimo
FOR EACH ROW
EXECUTE FUNCTION alteraDiponivelLivro();


CREATE OR REPLACE FUNCTION validaCliente()
RETURNS TRIGGER AS $$
BEGIN
    NEW.nome := LOWER(NEW.nome);
	IF NEW.data_reg >= CURRENT_DATE THEN
        RAISE EXCEPTION 'A data de registro (%), deve ser anterior a data atual', NEW.data_reg;
    END IF;
	NEW.CPF := regexp_replace(NEW.CPF, '(\d{3})(\d{3})(\d{3})(\d{2})', '\1.\2.\3-\4');
	RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_validaCliente
BEFORE INSERT OR UPDATE ON Cliente
FOR EACH ROW
EXECUTE FUNCTION validaCliente();

CREATE OR REPLACE FUNCTION validaLivro()
RETURNS TRIGGER AS $$
BEGIN
    NEW.Titulo := LOWER(NEW.Titulo);
	NEW.Categoria := LOWER(NEW.Categoria);
    NEW.ISBN := regexp_replace(NEW.ISBN, '(\d{3})(\d{1})(\d{2})(\d{6})(\d{1})', '\1-\2-\3-\4-\5');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_validaLivro
BEFORE INSERT OR UPDATE ON Livro
FOR EACH ROW
EXECUTE FUNCTION validaLivro();
