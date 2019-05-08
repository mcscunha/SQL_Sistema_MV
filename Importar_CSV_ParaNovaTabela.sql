-- Na linha de comando - para indicar onde os arquivos CSV ficarao
-- cd /oracle/feeds/
-- mkdir xtern
-- mkdir xtern/mySID
-- mkdir xtern/mySID/data

-- Criar o diretorio para o Oracle acessar
create or replace directory xtern_data_dir as '/oracle/feeds/xtern/mySID/data';

-- Dar direitos de leitura e escrita no diretorio
grant read, write on directory xtern_data_dir to bulk_load;

--
-- Criar a tabela DIRETAMENTE do CSV
-- Desta maneira, qq modificacao feita no CSV afetará os dados
-- É como se a tabela fosse, na verdade, uma VIEW do CSV
--
create table xtern_empl_rpt (
	empl_id varchar2(3),
    last_name varchar2(50),
    first_name varchar2(50),
    ssn varchar2(9),
    email_addr varchar2(100),
    years_of_service number(2,0)
    )
    
	organization external (
		default directory xtern_data_dir
        access parameters (
			records delimited by newline
			fields terminated by ','
        )
		location ('employee_report.csv')  
    );
