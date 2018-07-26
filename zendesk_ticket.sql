create procedure zendesk_ticket()
  BEGIN
truncate table plan.zendesk_ticket;
insert into plan.zendesk_ticket ( id_ticket,	 created_at,	 custom_data_da_venda_net_sales,	 updated_at,	 login_employee,	 dominio,	 name_analista,	 organization_id,	 name_org,	 subject,	 description,	 group_id,	 name_group,	 custom_data_do_agendamento_,	 custom_data_agendamento_net_sales,	 custom_numero_da_proposta_,	 custom_numero_do_contrato,	 custom_numero_do_contrato_net_sales,	 custom_upgrade_,	 custom_tv,	 custom_internet,	 custom_telefone_fixo,	 custom_celular_multi_,	 custom_quantidade_de_dependentes_,	 custom_codigo_do_combo,	 custom_nome_do_plano_multi_,	 custom_nome_do_plano_de_tv_,	 custom_nome_do_plano_de_internet_,	 custom_nome_do_plano_de_telefone_fixo_,	 custom_valor_contratado,	 custom_status_ligacao,	 custom_status_contrato_net_sales,	 custom_status_bko_,	 custom_tratativa_bko_,	 custom_tratativa_sac_,	 custom_tipo_net_sales,	 custom_tipo_de_pendencias,	 custom_motivo_da_quebra_,	 custom_forma_de_pagamento,	 custom_data_de_conexao_net_sales_,	 custom_data_cancelamento_net_sales_)
select id_ticket,
 convert_tz(created_at, 'UTC', 'America/Sao_Paulo'),
 CASE WHEN custom_data_da_venda_net_sales = '0000-00-00' THEN null else custom_data_da_venda_net_sales end as custom_data_da_venda_net_sales,
 convert_tz(updated_at, 'UTC', 'America/Sao_Paulo'),
 login_employee,
 dominio,
 name_analista,
 organization_id,
 name_org,
 subject,
 description,
 group_id,
 name_group,
 CASE WHEN custom_data_do_agendamento_ = '0000-00-00' THEN null else custom_data_do_agendamento_ end as custom_data_do_agendamento_,
 CASE WHEN custom_data_agendamento_net_sales = '0000-00-00' THEN null else custom_data_agendamento_net_sales end as custom_data_agendamento_net_sales,
 custom_numero_da_proposta_,
 custom_numero_do_contrato,
 custom_numero_do_contrato_net_sales,
 custom_upgrade_,
 custom_tv,
 custom_internet,
 custom_telefone_fixo,
 custom_celular_multi_,
 custom_quantidade_de_dependentes_,
 custom_codigo_do_combo,
 custom_nome_do_plano_multi_,
 custom_nome_do_plano_de_tv_,
 custom_nome_do_plano_de_internet_,
 custom_nome_do_plano_de_telefone_fixo_,
 custom_valor_contratado,
 custom_status_ligacao,
 custom_status_contrato_net_sales,
 custom_status_bko_,
 custom_tratativa_bko_,
 custom_tratativa_sac_,
 custom_tipo_net_sales,
 custom_tipo_de_pendencias,
 custom_motivo_da_quebra_,
 custom_forma_de_pagamento,
 CASE WHEN custom_data_de_conexao_net_sales_ = '0000-00-00' THEN null else custom_data_de_conexao_net_sales_ end as custom_data_de_conexao_net_sales_,
 CASE WHEN custom_data_cancelamento_net_sales_ = '0000-00-00' THEN null else custom_data_cancelamento_net_sales_ end as custom_data_cancelamento_net_sales_
 from plan.zendesk_ticket_aux ;
 
 END;

