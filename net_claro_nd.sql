create procedure NET_CLARO_ND()
  BEGIN
SET @vardate := (select nr_ano_mes from plan.NET_E_CLARO_ND order by nr_ano_mes desc limit 1);
delete from plan.NET_CLARO_ND where NR_ANO_MES = @vardate;
INSERT INTO plan.NET_CLARO_ND
select distinct 
nr_ano_mes,
CAST(STR_TO_DATE(DT, '%m/%d/%Y') as date) as DT,
DAY(STR_TO_DATE(DT, '%m/%d/%Y'))  as `day`,
MONTH(STR_TO_DATE(DT, '%m/%d/%Y')) as `month`,
YEAR(STR_TO_DATE(DT, '%m/%d/%Y')) as `year`,
nr_contrato,
nm_tipo_ass_domicilio,
nm_indicador_negocio,
id_login_user_cadastro,
nr_cpf_cnpj_vendedor,
nm_vendedor,
sub.login,
sub.login_manager,
produto_atual,
CAST(STR_TO_DATE(dt_solicitacao, '%m/%d/%Y') as date) as dt_solicitacao,
CAST(STR_TO_DATE(dt_venda, '%m/%d/%Y') as date) as dt_venda,
nm_cidade,
nm_regional,
nm_cluster,
nm_subcluster,
If( nm_indicador_negocio = 'Venda Bruta', 1, 0 ) as Venda_Bruta,
If( nm_indicador_negocio = 'Instalação', 1, 0 ) as Instalacao,
If( nm_indicador_negocio = 'Desistência', 1, 0 ) as Desistencia,
nm_marca



from plan.NET_E_CLARO_ND as lt
Left join (	
				 Select
			numero_do_contrato as contrato,
			empvc.vocalcom_id as vocalcom_id,
			emp.employee_id as employee_id,
			substring_index(u.email, '@', 1) as login,
            mg.login_manager

			from zendesk_2.propostas zd
			left join zendesk_2.users u on zd.vendedor = u.id
			left join bi_db.dim_employees emp on emp.login = substring_index(u.email, '@', 1)
			left join (select * from bi_db.dim_employee_vocalcom where vocalcom_id <> 4216) empvc on emp.employee_id = empvc.employee_id
			left join bi_db.dim_employee_manager as mg on mg.employee_id = emp.employee_id and mg.date_to > date(zd.created_time) and mg.date_from <= date(zd.created_time)
			where numero_do_contrato is not null

			
            
                                               union
            
                                                select
			replace(replace(replace(replace(replace(zh.numero_do_contrato, '-',''), '/',''), ' ', ''), '"', ''), '*', '') as contrato,
			empvc.vocalcom_id,
			empvc.employee_id,
			emp.login,
            mg.login_manager

			from bi_v2.raw_zh_oportunidades as zh
			Left join bi_db.dim_employee_zh as empzh on empzh.zoho_id = zh.smownerid
			Left join bi_db.dim_employees as emp on empzh.employee_id = emp.employee_id
			Left join bi_db.dim_employee_vocalcom as empvc on empvc.employee_id = emp.employee_id
			left join bi_db.dim_employee_manager as mg on mg.employee_id = emp.employee_id and mg.date_to > date(zh.created_time) and mg.date_from <= date(zh.created_time)
			where zh.numero_do_contrato is not null and zh.created_time BETWEEN DATE_SUB(curdate(), INTERVAL 90 DAY) and curdate() 

			) as sub on sub.contrato = lt.nr_contrato


where nr_ano_mes = @vardate and lt.nm_visao_analise like 'domic%lio';
END;

