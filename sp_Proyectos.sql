
CREATE PROCEDURE sp_FiltrarProyectosDinamico (
@estado varchar(20)=null,
@tipo varchar(50)=null, 
@areaCientifica varchar(50)=null, 
@objSocioeconomico varchar(100)=null, 
@ejePlanes varchar(50)=null, 
@unidadInvestigacion varchar(100)=null,
@fechaInicioEstimada varchar(10)=null, 
@fechaInicioReal varchar(10)=null,
@fechaFinalEstimada varchar(10)=null,
@fechaFinalReal varchar(10)=null,
@canton varchar(25)=null,
@region varchar(20)=null,
@objDesarrolloSostenible varchar(60)=null)
AS
BEGIN
   DECLARE @sql nvarchar(max)
   SET @sql = 'select distinct p.Codigo, p.Titulo, es.Nombre as Estado, t.Nombre as Tipo, a.Nombre as AreaConocimiento,
				os.Nombre as ObjetivoSocioEconomico,ep.Nombre as EjeDePlanes, i.Nombre as UnidadInvestigacion, 
				p.FechaInicioEstimada, p.FechaInicioReal, p.FechaFinalizacionEstimada, p.FechaFinalizacionReal
				from Proyectos as p
					inner join AreasConocimiento as a on p.AreaConocimiento = a.Codigo
					inner join UnidadesInvestigacion as i on p.UnidadInvestigacion = i.Codigo
					inner join TiposProyecto as t on p.Tipo = t.Codigo
					inner join ObjetivosSocioEconomicos as os on p.ObjetivoSocioEconomico = os.Codigo
					inner join EjesDePlanes as ep on p.EjeDePlanes = ep.Codigo
					inner join EstadosProyecto as es on p.Estado = es.Codigo
					left join CantonesProyecto as cp on p.Codigo = cp.Proyecto
					left join Cantones as cant on cant.Codigo = cp.Canton
					left join RegionesProyecto as regp on regp.Proyecto = p.Codigo
					left join Regiones as reg on reg.Codigo = regp.Region 
					left join ObjetivosDesarrolloSostenibleProyecto as objdp on objdp.Proyecto = p.Codigo
					left join ObjetivosDesarrolloSostenible as objd on objd.Codigo = objdp.ObjetivoDesarrolloSostenible 
				WHERE 1=1'

    IF @estado IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND es.Nombre = ''' + @estado + ''''
	END
		
   IF @tipo IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND t.Nombre = ''' + @tipo + ''''
	END 

   IF @areaCientifica IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND a.Nombre = ''' + @areaCientifica + ''''
	END 
	
   IF @objSocioeconomico IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND os.Nombre = ''' + @objSocioeconomico + ''''
	END
	
   IF @ejePlanes IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND ep.Nombre = ''' + @ejePlanes + ''''
	END
	
   IF @unidadInvestigacion IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND i.Nombre = ''' + @unidadInvestigacion + ''''
	END
		
   IF @fechaInicioEstimada IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND p.FechaInicioEstimada = ''' + @fechaInicioEstimada + ''''
	END
		
   IF @fechaInicioReal IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND p.FechaInicioReal = ''' + @fechaInicioReal + ''''
	END
				
   IF @fechaFinalEstimada IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND p.FechaFinalizacionEstimada = ''' + @fechaFinalEstimada + ''''
	END
		
   IF @fechaFinalReal IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND p.FechaFinalizacionReal = ''' + @fechaFinalReal + ''''
	END
   IF @canton IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND cant.Nombre = ''' + @canton + ''''
	END
			
   IF @region IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND reg.Nombre = ''' + @region + ''''
	END
			
   IF @objDesarrolloSostenible IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND objd.Nombre = ''' + @objDesarrolloSostenible + ''''
	END
	
   EXECUTE sp_executesql @sql
END
