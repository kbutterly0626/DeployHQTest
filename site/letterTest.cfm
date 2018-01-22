<cfset c = createObject('component','cfcs.claims')>
<cfset session.letterObj = createObject('component','cfcs.letters')>
<cfset csli = 3783657>

<cfquery name="ad" datasource="#appdsn#">
	SELECT csl.*, cs.comp_id, cs.coop_submit_id FROM tbl_coop_submit_line csl
	join tbl_coop_status_log cl on cl.coop_status_log_expdate = '9999-12-31' and cl.coop_submit_line_id = csl.coop_submit_line_id
	join tbl_coop_submit cs on cs.coop_submit_id = csl.coop_submit_id
	WHERE coop_status_log_id = #csli#
</cfquery>

<cfset letterId = c.createletter(
		claimStatus='AUTOAPPR',
		ad=ad,
		coop_status_log_id = csli,
		dsn = appdsn)>

<cfset session.letterObj.sendLetter(letterId)>