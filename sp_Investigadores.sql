CREATE PROCEDURE sp_FiltrarInvestigadoresDinamico (
@gradoAcademico varchar(100)=null,
@edadDesde int=null, 
@edadHasta int=null,
@sexo int=null)
AS
BEGIN
	DECLARE @sql nvarchar(max)
	SET @sql = 'select PrimerApellido, SegundoApellido, Investigadores.Nombre, Identificacion, 
				CorreoElectronico1 as CorreoPrincipal, g.Nombre as GradoAcademico,
				DATEDIFF(year, FechaNacimiento, GETDATE()) as Edad, Sexo 
				from Investigadores 
				inner join GradosAcademicos as g on g.Codigo = Investigadores.GradoAcademico
				where 1=1'

	IF @gradoAcademico IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND g.Nombre = ''' + @gradoAcademico + ''''
	END
		
    IF @edadDesde IS NOT NULL AND @edadHasta IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND DATEDIFF(year, FechaNacimiento, GETDATE()) BETWEEN ' + CAST(@edadDesde AS VARCHAR) + ' AND ' + CAST(@edadHasta AS VARCHAR) + ''
	END 

    IF @sexo IS NOT NULL
	BEGIN 
		SET @sql = @sql + ' AND Sexo = ' + CAST(@sexo AS VARCHAR) + ''
	END 
	
	EXECUTE sp_executesql @sql
END