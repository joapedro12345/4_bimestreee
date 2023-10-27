--1--
DELIMITER //

CREATE FUNCTION total_livros_por_genero(nome_genero VARCHAR(255)) returns int
deterministic
BEGIN
    DECLARE total INT;
    DECLARE genero_id INT;
    
    SELECT id INTO genero_id FROM Genero WHERE nome_genero = nome_genero;
    SELECT COUNT(*) INTO total FROM Livro WHERE id_genero = genero_id;
    
    RETURN total;
END//

DELIMITER ;

--2--
DELIMITER //
CREATE FUNCTION listar_livros_por_autor(primeiro_nome VARCHAR(255), ultimo_nome VARCHAR(255)) RETURNS TEXT
BEGIN
    DECLARE list_livros TEXT;
    DECLARE aut_id INT;
    
    SELECT id INTO autor_id FROM Autor WHERE primeiro_nome = primeiro_nome AND ultimo_nome = ultimo_nome;
    
    SELECT GROUP_CONCAT(titulo) INTO lista_livros 
    FROM Livro 
    WHERE id IN (SELECT id_livro FROM Livro_Autor WHERE id_autor = aut_id);
    
    RETURN list_livros;
END//

DELIMITER ;

--3--
DELIMITER //
CREATE FUNCTION atualizar_resumos()
returns text
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE liv_id INT;
    DECLARE novo_resumo TEXT;
    DECLARE cur CURSOR FOR SELECT id FROM Livro;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO liv_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET novo_resumo = CONCAT(resumo, ' Este é um excelente livro!');
        UPDATE Livro SET resumo = novo_resumo WHERE id = liv_id;
    END LOOP;

    CLOSE cur;
END//

DELIMITER ;
