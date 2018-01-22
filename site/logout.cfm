<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Ford Toolbox</title>
	<!--- <cfinclude TEMPLATE="../inc_style.css"> --->
</head>

<body>

<cfinclude template="qry_delete_active.sql">

<script language="JavaScript">
<cfoutput>
self.onerror = function() 
	{
		parent.location.href = "#AppRegionSSLPrefix##appregionurl#/index.cfm?source=#user_source#";
		return true;
	}

parent.location.href = "#AppRegionSSLPrefix##appregionurl#/index.cfm?source=#user_source#";
</cfoutput>		
</script>


</body>
</html>

