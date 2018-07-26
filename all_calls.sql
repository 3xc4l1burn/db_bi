create procedure ALL_CALLS()
  BEGIN 
DELETE FROM plan.ALL_CALLS where `date` BETWEEN DATE_SUB(curdate(), INTERVAL 90 DAY) and curdate(); 
INSERT INTO plan.ALL_CALLS  
Select
Date(data_hora_ligacao) as date
,Hour(data_hora_ligacao) as hora
,sub.operacao
,sub.qname
,sub.tipo
,count( If( tempo_fila <= 5 and tempo_falado = 0 and tempo_wrapup = 0, null, ultima_fila) ) as 'Entrada_Fila'
,sum( If( tempo_fila > 5 and tempo_falado = 0 and tempo_wrapup = 0 , abandonada, 0) ) as 'Abandonada_Fila'
,sum(if(tempo_falado > 0 or tempo_wrapup > 0, 1, 0)) as 'Atendida'
,AVG(If(tempo_falado > 0 or tempo_wrapup > 0, tempo_falado , null)) as 'Tempo_Falado'
,AVG(If(tempo_falado > 0 or tempo_wrapup > 0, tempo_wrapup , null)) as 'Tempo_Finalizacao'
,AVG(If(tempo_falado > 0 or tempo_wrapup > 0, tempo_wrapup , null)) * sum(if(tempo_falado > 0 or tempo_wrapup > 0, 1, 0)) as 'Tempo_Finalizacao_Produto'
,AVG(If(tempo_falado > 0, tempo_falado , null)) as 'TMA'
,AVG(If(tempo_falado > 0, tempo_falado , null)) * sum(if(tempo_falado > 0 or tempo_wrapup > 0, 1, 0)) as 'TMA Produto' 
,AVG(If(tempo_falado > 0 or tempo_wrapup > 0, tempo_falado + tempo_wrapup , null)) as 'TMO'
,AVG(If(tempo_falado > 0 or tempo_wrapup > 0, tempo_falado + tempo_wrapup , null)) * sum(if(tempo_falado > 0 or tempo_wrapup > 0, 1, 0)) as 'TMO Produto'

from (
  .

Select
indice
,data_hora_ligacao
,CASE	
		 WHEN ultima_campanha like 'NET_SMS%' Then 'NET_SMS' 
         when ultima_fila like 'Assine%Nao%Cabeado' Then 'CLARO'
         when ultima_fila like 'Assine%' Then 'NET'
         WHEN ultima_fila LIKE '%NET%NAO%CABEADO%' THEN 'CLARO'
         WHEN ultima_fila LIKE 'NET_CABEADO' THEN 'NET'
         WHEN ultima_fila LIKE 'CLARO_Transferencia_Net' THEN 'NET'
         WHEN ultima_fila LIKE 'CLARO_Growth' THEN 'CLARO'
         WHEN ultima_fila LIKE 'CLARO_TimeOut' THEN 'CLARO'
         WHEN ultima_fila LIKE 'CLARO_UPGrade' THEN 'CLARO'
         WHEN ultima_fila LIKE 'CLARO_URA_Receptivo' THEN 'CLARO'
         WHEN ultima_fila LIKE '%NET%UPGRADE%' THEN 'NET_UPGRADE'
         WHEN ultima_fila LIKE 'NET_Shopping_Cart' THEN 'NET_SHOPPING_CART'
         WHEN ultima_fila LIKE 'teste_BI_cabeado' THEN 'TESTE_BI_CABEADO'
         when ultima_fila like '%NET%' Then 'NET'
         when ultima_fila like '%CLARO%' Then 'CLARO'
         WHEN ultima_campanha like 'NET_Out_Tabulacao' Then 'NET_ATIVO'
        WHEN ultima_campanha like 'NET_Out_Abandono' Then 'NET_ATIVO'
        WHEN ultima_campanha like 'NET_ATIVO_MANUAL' Then 'NET_ATIVO'
        WHEN ultima_campanha like 'NET_SHOPPING_CART_MANUAL' Then 'NET_SHOPPING_CART'
         END AS operacao
,CASE 
        WHEN ultima_campanha like 'Net_Sms_Abandonado' Then 'Net_Sms_Abandonado' 
        WHEN ultima_campanha like 'Net_Sms_Nagendado' Then 'Net_Sms_Nagendado'
        WHEN ultima_campanha like 'Net_Sms_Upgrade' Then 'Net_Sms_Upgrade'
        WHEN ultima_campanha like 'NET_Out_Tabulacao' Then 'NET_Out_Tabulacao'
        WHEN ultima_campanha like 'NET_Out_Abandono' Then 'NET_Out_Abandono'
        WHEN ultima_campanha like 'NET_ATIVO_MANUAL' Then 'NET_ATIVO_MANUAL' 
       WHEN ultima_campanha like 'NET_SHOPPING_CART_MANUAL' Then 'NET_SHOPPING_CART_MANUAL'
        ELSE ultima_fila
        END as qname
,case
	when primeira_campanha like '%c2c%' or ultima_campanha like '%c2c%' Then 'c2c'
                when id_ultima_fila = 18 or id_ultima_fila = 38  Then 'Outbound-call'
    else tipo_ligacao end as tipo
,duracao_total
,tempo_na_ura
,tempo_fila
,tempo_falado
,tempo_wrapup
,telefone_cliente
,telefone_escale
,did_primeira_campanha
,primeira_campanha
,did_ultima_campanha
,ultima_campanha
,sem_agente
,abandonada
,id_primeira_fila
,primeira_fila
,id_ultima_fila
,ultima_fila
,id_primeiro_agente
,primeiro_agente
,capitao_primeiro_agente
,id_ultimo_agente
,ultimo_agente
,capitao_ultimo_agente
,ligacao_transferida
,finalizado_pelo_agente
,tabulacao

From bi_db.view_calls_escale

where data_hora_ligacao BETWEEN DATE_SUB(curdate(), INTERVAL 90 DAY) and curdate()

) as sub

where
tipo not in('Outbound call', 'bis')
and qname not like '%Amil%'
and qname not in('ELEKTRO_SMS','NET_Rota_Proativa', 'teste_BI_cabeado', 'DID 9997', 'Fila_Net_01_teste', 'FILA_MARILIA', 'Default queue', 'Fila_Elektro_01', 'RECEPTIVO_VCL', 'teste_BI_nao_cabeado', 'K12', 'HML_ESCALE', 'SAC', 'AMS_C2C')

group by Date(data_hora_ligacao), Hour(data_hora_ligacao), qname, tipo;
END;

