CREATE PROCEDURE sp_FiltrarProyectosXInvestigadorDinamico (
@estado varchar(20)=null,
@areaCientifica varchar(50)=null, 
@fechaInicioReal varchar(10)=null,
@NombreCompleto varchar(100)=null,
@edadDesde int=null, 
@edadHasta int=null)
AS
BEGIN
   DECLARE @sql nvarchar(max)
   SET @sql = 'select distinct p.Codigo, p.Titulo, es.Nombre as Estado, t.Nombre as Tipo, a.Nombre as AreaConocimiento,
				os.Nombre as ObjetivoSocioEconomico,ep.Nombre as EjeDePlanes, i.Nombre as UnidadInvestigacion, 
				p.FechaInicioEstimada, p.FechaInicioReal, p.FechaFinalizacionEstimada, p.FechaFinalizacionReal, 
				DATEDIFF(year, iv.FechaNacimiento, GETDATE()) as Edad, iv.PrimerApellido +'' ''+ iv.SegundoApellido +'' ''+ iv.Nombre as Investigador
				from Proyectos as p
					inner join AreasConocimiento as a on p.AreaConocimiento = a.Codigo
					inner join UnidadesInvestigacion as i on p.UnidadInvestigacion = i.Codigo
					inner join TiposProyecto as t on p.Tipo = t.Codigo
					inner join ObjetivosSocioEconomicos as os on p.ObjetivoSocioEconomico = os.Codigo
					inner join EjesDePlanes as ep on p.EjeDePlanes = ep.Codigo
					inner join EstadosProyecto as es on p.Estado = es.Codigo
					left join InvestigadoresProyecto as ipr on ipr.Proyecto = p.Codigo
					left join Investigadores as iv on iv.Codigo = ipr.Investigador
				where 1=1'
	
	IF @estado IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND es.Nombre = ''' + @estado + ''''
	END

	IF @areaCientifica IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND a.Nombre = ''' + @areaCientifica + ''''
	END 

	IF @fechaInicioReal IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND p.FechaInicioReal = ''' + @fechaInicioReal + ''''
	END

	IF @NombreCompleto IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND iv.PrimerApellido + '' '' + iv.SegundoApellido + '' '' + iv.Nombre LIKE ''%' + @NombreCompleto + '%'''
	END

	IF @edadDesde IS NOT NULL AND @edadHasta IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND DATEDIFF(year, iv.FechaNacimiento, GETDATE()) BETWEEN ' + CAST(@edadDesde AS VARCHAR) + ' AND ' + CAST(@edadHasta AS VARCHAR) + ''
	END 

	EXECUTE sp_executesql @sql
END