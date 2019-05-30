create or replace FUNCTION                  FC_GRAVAR_ARQUIVO_DSV ( 
                        p_query             in varchar2,
                        p_dir               in varchar2,
                        p_filename          in varchar2,                        
                        p_separator         in varchar2 default ',',
                        p_inclui_cabecalho  in varchar2 default 'N'
                        )
    return number
    is
       l_output        utl_file.file_type;
       l_theCursor     integer default dbms_sql.open_cursor;
       l_columnValue   varchar2(4000);
       l_status        integer;
       l_colCnt        number default 0;
       l_separator     varchar2(10) default '';
       l_cnt           number default 0;       
       l_columns       dbms_sql.desc_tab;
   begin
      dbms_output.enable(null);
      --dbms_output.put_line(p_query);

      l_output := utl_file.fopen( p_dir, p_filename, 'w' );
      
      -- faz parse no SQL:
      dbms_sql.parse(  l_theCursor,  p_query,
                                            dbms_sql.native );
            
      -- verifica se deve incluir cabecalho com nome das colunas do SQL:
      IF p_inclui_cabecalho = 'S' THEN        
          -- recupera nomes das colunas do SQL e qtde total de colunas:  
          dbms_sql.describe_columns(l_theCursor, l_colCnt, l_columns);
      
          -- efetua loop para gravar no arquivo os nomes das colunas
          for i in 1 .. l_columns.count loop
              --dbms_output.put_line(l_columns(i).col_name);
              utl_file.put( l_output, l_columns(i).col_name);
              -- grava separador de colunas enquanto nao for ultima coluna:
              if i < l_columns.count then 
                    utl_file.put( l_output, p_separator );
              end if;
          end loop;
          utl_file.new_line( l_output );
      END IF;
     
      -- percorre todas as colunas:
      for i in 1 .. 255 loop
           begin
               dbms_sql.define_column( l_theCursor, i,
                                       l_columnValue, 4000 );
               l_colCnt := i;
           exception
               when others then
                   if ( sqlcode = -1007 ) then exit;
                   else
                       raise;
                   end if;
           end;
      end loop;
      
      -- executa o SQL:  
      l_status := dbms_sql.execute(l_theCursor);

      -- recupera valores e grava-os em arquivo texto conforme diretorio e filename especificados:
      loop
           exit when ( dbms_sql.fetch_rows(l_theCursor) <= 0 );
           l_separator := '';
          for i in 1 .. l_colCnt loop
               dbms_sql.column_value( l_theCursor, i,
                                      l_columnValue );
               utl_file.put( l_output,
                             l_separator || l_columnValue );
               l_separator := p_separator;
           end loop;
           utl_file.new_line( l_output );
           l_cnt := l_cnt+1;
      end loop;
      
      -- libera recursos fechando o cursor e o arquivo:
      dbms_sql.close_cursor(l_theCursor);
      utl_file.fclose( l_output );
      RETURN L_CNT;
end;

/*
E abaixo um exemplo de como utilizá-la:

select FC_GRAVAR_ARQUIVO_DSV('select * FROM HR.EMPLOYEES', 'RELAT_DIR', 'employees.dsv',';', 'S') from dual;

Resultado:
	O arquivo employees.dsv contendo um cabeçalho com  o nome de cada coluna utilizada no 
	SQL + os registros da tabela HR.EMPLOYEES e campos separados pelo caractere ; será criado
	no objeto diretório RELAT_DIR. Importante: o dono da função tem que ter o privilégio
	READ,WRITE neste objeto. É importante ressaltar que o 3º (p_separator) e 4º parâmetros
	(p_inclui_cabecalho) da função são opcionais. Caso você não forneça valor para eles serão
	usados os valores default que podem ser observados no cabeçalho da função.
	
*/