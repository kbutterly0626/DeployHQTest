<cfcomponent>

	<cffunction name="retrieveRegions" access="public" hint="returns a list of Regions" returntype="query">
	<cfargument name="regionCode" required="No" type="string">
	<cfargument name="regionName" required="No" type="string">
	<cfargument name="regionActive" required="No" type="boolean">
	<cfargument name="regionFilter" required="No" type="string">

		<CFQUERY DATASOURCE="#request.AppDSN#" NAME="retrieveRegions">
			SELECT *
			FROM TBL_REGION
			WHERE 1=1
			<cfif isDefined("arguments.regionCode")>
				AND REGION_CODE = '#arguments.regionCode#'
			</cfif>
			<cfif isDefined("arguments.regionName")>
				AND REGION_NAME = '#arguments.regionName#'
			</cfif>
			<cfif isDefined("arguments.regionActive")>
				AND REGION_ACTIVE = #arguments.regionActive#
			</cfif>
			<cfif isDefined("arguments.regionFilter")>
				AND REGION_CODE IN (#listQualify(arguments.regionFilter,"'")#)
			</cfif>

			ORDER BY REGION_CODE, REGION_ORDER
		</CFQUERY>

	<cfreturn retrieveRegions>

	</cffunction>

	<cffunction name="retrieveDistricts" access="public" hint="returns a list of Districts" returntype="query">
		<cfargument name="districtId" required="No" type="numeric">
		<cfargument name="regionCode" required="No" type="string">
		<cfargument name="districtActive" required="No" type="boolean">
		<cfargument name="districtFilter" required="No" type="string">

		<CFQUERY DATASOURCE="#request.appDSN#" NAME="retrieveDistricts">
			SELECT *
			FROM TBL_MARKET m
				INNER JOIN TBL_REGION r on r.REGION_CODE = m.REGION_CODE
			WHERE 1=1
			<cfif isDefined("arguments.districtId")>
				AND m.MARKET_ID = #arguments.districtId#
			</cfif>
			<cfif isDefined("arguments.regionCode")>
				AND r.REGION_CODE = '#arguments.regionCode#'
			</cfif>
			<cfif isDefined("arguments.districtActive")>
				AND m.MARKET_ACTIVE = #arguments.districtActive#
			</cfif>
			<cfif isDefined("arguments.districtFilter")>
				AND m.MARKET_CODE IN (#listQualify(arguments.districtFilter,"'")#)
			</cfif>
			ORDER BY r.REGION_ORDER, r.REGION_CODE, m.MARKET_ORDER, m.MARKET_NAME
		</CFQUERY>

	<cfreturn retrieveDistricts>

	</cffunction>



	<cffunction name="retrieveUserRegionsAndMarkets" access="public" hint="returns a structure of values they should be able to see in the drop down boxes based upon their permissions list" returntype="struct">
	<cfargument name="userId" required="No" type="numeric">

		<cfset userPermissions = structNew()>

		<!--- This code queries to find out what values they should be able to see in the drop down boxes based upon their permissions.  Based upon the results here, the regions, markets, and dealers queries below get a filter placed on them. --->
		<cfquery name="checkForDropDownPermissions" datasource="#request.appDSN#">
			SELECT up.USER_PROPERTIES_VALUE, p.PROPERTY_NAME
			FROM TBL_USER_PROPERTIES up
			INNER JOIN TBL_PROPERTY p on up.PROPERTY_ID = p.PROPERTY_ID 
			WHERE up.USER_ID = #arguments.userId#
			AND (
					(p.property_name = 'DEALERPERM' AND isnumeric(UP.user_properties_value)=1)
					 OR 
					(P.property_name != 'DEALERPERM')
				)
		</cfquery>
		
		<cfif valueList(checkForDropDownPermissions.PROPERTY_NAME) CONTAINS "REGIONPERM">
		
			<cfquery name="getPermissionFiltersRegion" dbtype="query">
				SELECT USER_PROPERTIES_VALUE
				FROM checkForDropDownPermissions
				WHERE PROPERTY_NAME = 'REGIONPERM'
			</cfquery>

			<cfset userPermissions.regionFilter = valueList(getPermissionFiltersRegion.USER_PROPERTIES_VALUE)>
		</cfif>
		
		<cfif valueList(checkForDropDownPermissions.PROPERTY_NAME) CONTAINS "DISTRICTPERM">
		
			<cfquery name="getPermissionFiltersDistrict" dbtype="query">
				SELECT USER_PROPERTIES_VALUE
				FROM checkForDropDownPermissions
				WHERE PROPERTY_NAME = 'DISTRICTPERM'
			</cfquery>
		
			<cfset userPermissions.districtFilter = valueList(getPermissionFiltersDistrict.USER_PROPERTIES_VALUE)>
		
		</cfif>
		
		<cfif valueList(checkForDropDownPermissions.PROPERTY_NAME) CONTAINS "DEALERPERM">
		
			<cfquery name="getPermissionFiltersDealer" dbtype="query">
				SELECT USER_PROPERTIES_VALUE
				FROM checkForDropDownPermissions
				WHERE PROPERTY_NAME = 'DEALERPERM'
			</cfquery>
		
			<cfset userPermissions.dealerFilter = valueList(getPermissionFiltersDealer.USER_PROPERTIES_VALUE)>
		
		</cfif>

	<cfreturn userPermissions>

	</cffunction>
	<cffunction name="retrieveRegionsByBrand" access="remote" hint="returns a list of Districts" returnformat="plain" >
		<cfargument name="regionCode" required="No" type="string">
		<cfargument name="regionName" required="No" type="string">
		<cfargument name="regionActive" required="No" type="boolean">
		<cfargument name="regionFilter" required="No" type="string">
		<cfargument name="brand" required="no" default="dual" type="string">
		<CFQUERY DATASOURCE="#request.AppDSN#" NAME="retrieveRegions">
			SELECT DISTINCT R.REGION_NAME,R.REGION_CODE,R.REGION_DESC,R.REGION_ORDER
			FROM QRY_REGION R
			INNER JOIN 
			QRY_MARKET M on M.REGION_CODE = R.REGION_CODE
			WHERE 1=1
			<cfif isDefined("arguments.regionCode")>
				AND REGION_CODE = '#arguments.regionCode#'
			</cfif>
			<cfif isDefined("arguments.regionName")>
				AND REGION_NAME = '#arguments.regionName#'
			</cfif>
			<cfif isDefined("arguments.regionActive")>
				AND REGION_ACTIVE = #arguments.regionActive#
			</cfif>
			<cfif isDefined("arguments.regionFilter")>
				AND REGION_CODE IN (#listQualify(arguments.regionFilter,"'")#)
			</cfif>
			<cfif structKeyExists(arguments,"brand") and arguments.brand NEQ "dual">
				<cfif arguments.brand eq "Chrysler">
					And M.comp_is_Fiat = 0 and M.comp_is_chrysler = 0
				<cfelseif arguments.brand eq "Fiat">
					And M.comp_is_Fiat = 1 and M.comp_is_chrysler = 0
				</cfif>
			</cfif>
			ORDER BY REGION_CODE, REGION_ORDER
		</CFQUERY>
		<cfset var vReturnStart = "" />
		<cfset var vReturnEnd = "">
		<cfset var vReturnGuts = "">
		<cfset cnt = 1>
		<cfsilent>
		<cfoutput>
			<cfsavecontent variable="vReturnGuts">
			{ "market" : [
				{ "id" : "","name":"All Regions" }<cfif retrieveRegions.recordcount>,</cfif>
			<cfloop query="retrieveRegions">
				{ "id" : "#region_code#","name":"#region_name#" }<cfif cnt lt retrieveRegions.recordCount>,</cfif>
				<cfset cnt +=1>
			</cfloop>
			]}
			</cfsavecontent>
		</cfoutput>
		</cfsilent>
		<cfreturn vReturnGuts />	
	</cffunction>
	<cffunction name="retrieveMarketsByBrand" access="remote" hint="returns a list of Districts" returnformat="plain" >
			<cfargument name="districtId" required="No" type="numeric">
			<cfargument name="regionCode" required="No" type="string">
			<cfargument name="districtActive" required="No" type="boolean">
			<cfargument name="districtFilter" required="No" type="string">
		<cfargument name="brand" required="no" default="dual" type="string">
		<CFQUERY DATASOURCE="#request.AppDSN#" NAME="retrieveRegions">
			SELECT DISTINCT market_id,market_name
			FROM QRY_MARKET M
			
			WHERE 1=1
			<cfif isDefined("arguments.regionCode")>
				AND REGION_CODE = '#arguments.regionCode#'
			</cfif>
			<cfif isDefined("arguments.districtId")>
				AND MARKET_ID = '#arguments.districtId#'
			</cfif>
			<cfif isDefined("arguments.districtActive")>
				AND REGION_ACTIVE = #arguments.districtActive#
			</cfif>
			<cfif isDefined("arguments.districtFilter")>
				AND REGION_CODE IN (#listQualify(arguments.districtFilter,"'")#)
			</cfif>
			<cfif structKeyExists(arguments,"brand") and arguments.brand NEQ "dual">
				<cfif arguments.brand eq "Chrysler">
					And M.comp_is_Fiat = 0 and M.comp_is_chrysler = 1
				<cfelseif arguments.brand eq "Fiat">
					And M.comp_is_Fiat = 1 and M.comp_is_chrysler = 0
				</cfif>
			</cfif>
			ORDER BY MARKET_NAME
		</CFQUERY>
		<cfset var vReturnStart = "" />
		<cfset var vReturnEnd = "">
		<cfset var vReturnGuts = "">
		<cfset cnt = 1>
		<cfsilent>
		<cfoutput>
			<cfsavecontent variable="vReturnGuts">
			{ "market" : [
				{ "id" : "","name":"All Markets" }<cfif retrieveRegions.recordcount>,</cfif>
			<cfloop query="retrieveRegions">
				{ "id" : "#market_id#","name":"#market_name#" }<cfif cnt lt retrieveRegions.recordCount>,</cfif>
				<cfset cnt +=1>
			</cfloop>
			]}
			</cfsavecontent>
		</cfoutput>
		</cfsilent>
		<cfreturn vReturnGuts />	
	</cffunction>

	<cffunction name="retrieveDealersByMarketIdandBrand" access="remote" returnformat="plain">
		<cfargument name="marketId">
		<cfargument name="brand">
		<cfquery name="qryGetDealers" datasource="#application.AppDSN#">
			SELECT	DISTINCT TBL_COMPANY.COMP_ID, TBL_COMPANY.COMP_NAME, tbl_COMPANY.COMP_DEALER_CODE
			FROM	
					TBL_COMPANY
			Where 1=1
			AND		TBL_COMPANY.COMP_ACTIVE = 1
			AND		TBL_COMPANY.SUSPENSION_FG = 0
			<cfif structKeyExists(arguments,"brand") and arguments.brand NEQ "dual">
				<cfif arguments.brand eq "Chrysler">
					And TBL_COMPANY.comp_is_Fiat = 0 and tbl_company.comp_is_chrysler = 1
				<cfelseif arguments.brand eq "Fiat">
					And TBL_COMPANY.comp_is_Fiat = 1 and tbl_company.comp_is_chrysler = 0
				</cfif>
			</cfif>
			<CFIF structKeyExists(arguments,"marketId") and len(arguments.marketId)>
				and tbl_COMPANY.COMP_MARKET_ID = #arguments.marketId#
			</CFIF>
			order by tbl_company.comp_name
		</cfquery>
		
		<cfset var vReturnStart = "" />
		<cfset var vReturnEnd = "">
		<cfset var vReturnGuts = "">
		<cfset cnt = 1>
		
		<cfsilent>
		<cfoutput>
			<cfsavecontent variable="vReturnGuts">
			{ "dealer" : [
				{ "id" : "","name":"All Dealers" }<cfif qryGetDealers.recordcount>,</cfif>
			<cfloop query="qryGetDealers">
				{ "id" : "#comp_id#","name":"#trim(comp_name)# [#trim(COMP_DEALER_CODE)#]" }<cfif cnt lt qryGetDealers.recordCount>,</cfif>
				<cfset cnt +=1>
			</cfloop>
			]}
			</cfsavecontent>
		</cfoutput>
		</cfsilent>
		<cfreturn vReturnGuts />	
	</cffunction>

</cfcomponent>




