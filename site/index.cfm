
<!---
If user is active
	Redirect to secure portion of site
EndIf

Check for the existence of Login Info, in one of three formats:
	B- FORM username & password
	C- URL flag to check for existence of a cookie
If one of the formats is present, the relevant template is included.

If login info is not present, the user is redirected to the login screen.
            													         --->
<!--- ------------------------------------------------------------------ --->
<!---
	<h1>got here</h1>
	<cfabort>
--->

<CFIF AppSSLReq NEQ "NO">
	<CFIF CGI.SERVER_PORT_SECURE EQ 0>
		<cflocation url="#AppRegionSSLPrefix##AppRegionURL#/index.cfm" addtoken="No">
	</CFIF>
</CFIF>

<CFIF isDefined("session.user_id")>
	<cflocation url="#AppRegionSSLPrefix##AppRegionSecURL#/index.cfm" addtoken="No">
</CFIF>

<cfif structKeyExists(form,"username") and structKeyExists(form,"userfirst") and structKeyExists(form,"userlast")>
	<!---SSO from user site. --->
	<cfquery name="getUserPass" datasource="#appdsn#">
		Select user_pw,user_name from TBL_USERS where user_name = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar" >
		and user_first = <cfqueryparam value="#form.userfirst#" cfsqltype="cf_sql_varchar" >
		and user_last = <cfqueryparam value="#form.userlast#" cfsqltype="cf_sql_varchar" >
		and user_active = 1
	</cfquery>
	<cfif getUserPass.recordcount>
		<cfset form.user_pw = getUserPass.user_pw />
		<cfset form.user_name = getUserPass.user_name />
	</cfif>

</cfif>
<cfif not structKeyExists(session,"user_id") and not structKeyExists(form,"user_name")  and not structKeyExists(form,"user_pw")>
	<cflocation url="login/login.cfm" addtoken="no" />
</cfif>

<CFIF isDefined("form.User_Name") and isDefined("form.User_PW")>
	<CFINCLUDE template="login/inc_URL_Form_Validation.cfm">
<CFELSEIF isDefined("form.UserId") AND isDefined("form.sc")>
	<CFINCLUDE template="login/inc_SSO_UserId_Validation.cfm">
<CFELSEIF isDefined("form.User_Name") AND isDefined("form.compDealerCode")>
	<CFINCLUDE template="login/inc_Magis_Validation.cfm">
<CFELSE>

	<cfif structKeyExists(variables,"magisSSOUser") and magisSSOUsed IS 1>
		<!--- Using javascript due to frame issues with cflocation
		<cflocation url="#AppLoginURL#" addtoken="No">
		--->
		<cfoutput>
		<script type="text/javascript">
			<!--
			window.parent.location.replace("#AppLoginURL#");
			//-->
		</script>
		</cfoutput>
	<cfelse>
		<cflocation url="#AppLoginURL#" addtoken="No">
	</cfif>
</CFIF>

</body>
</html>
