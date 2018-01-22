
<!--- <cfdirectory action="LIST" directory="\\nsi-xio-pws5\nsiwebroot\COOP_CHRYSLER\PROD\SITE\Secure\COOP\submit_electronic" type="file" listInfo="name" name="fileList">
<!--- <cfdump var="#fileList#"><cfabort> --->


<cfquery dbtype="query" name="distinctFiles">
	SELECT DISTINCT reverse(name,".")
	FROM fileList
</cfquery>



<cfdump var="#distinctFiles#"> --->

<!--- 
<cfset letter = createObject("component", "cfcs.letters") />

<cfset attributes.ad.coop_submit_id = 378682 />
<cfset attributes.ad.coop_submit_line_id = 655146 />
<cfset attributes.ad.coop_submit_line_ad_start_date = "8/12/2013" />

<cfset attributes.letterTemplate = letter.retrieveLetterTemplates(coopStatusCode='AUTOAPPR')>
<cfset attributes.letter  = attributes.letterTemplate.letter_template_text>
<cfset attributes.subject = attributes.letterTemplate.letter_template_email_subject>
<cfset attributes.letter = replaceNoCase(attributes.letter,"##Publication_date##", dateFormat(attributes.ad.coop_submit_line_ad_start_date,'mmmm d, yyyy'), "ALL")>
<cfset attributes.letter = replaceNoCase(attributes.letter,"##claim_id##", attributes.ad.coop_submit_id, "ALL")>
<cfset attributes.letter = replaceNoCase(attributes.letter,"##ad_id##", attributes.ad.coop_submit_line_id, "ALL")>
<!--- <cfdump var="#attributes#"> --->
<cfset claimUserInfo.USER_EMAIL = "" />
<cfset dealerInfo.COMP_BILL_EMAIL = "" />
<cfset dealerInfo.COMP_SHIP_EMAIL = "" />

<cfif trim(claimUserInfo.USER_EMAIL) IS NOT "">
	<cfset emailToUse = trim(claimUserInfo.USER_EMAIL)>
<cfelseif trim(dealerInfo.COMP_BILL_EMAIL) IS NOT "">
	<cfset emailToUse = trim(dealerInfo.COMP_BILL_EMAIL)>
<cfelseif trim(dealerInfo.COMP_SHIP_EMAIL) IS NOT "">
	<cfset emailToUse = trim(dealerInfo.COMP_SHIP_EMAIL)>
<cfelse>
	<cfset emailToUse = "">
</cfif>

<!--- <cfoutput>#letter.insertLetter(74567, attributes.letterTemplate.letter_template_id, '', attributes.subject, attributes.letter, 3950715, 16961)#</cfoutput> --->
<cfset letterID = letter.insertLetter(74567, attributes.letterTemplate.letter_template_id, '', attributes.subject, attributes.letter, 3950715, 16961) />
<cfset letter.sendLetter(letterID) />
--->
<!--- 
<cfdump var="#letter.insertLetter(74567, 17, '', 'Testing', 'This is a test!', 3950715, 16961)#" />
 --->


<!--- <cfset ad = claim.getAd(662860,appdsn) />

<cfset status = claim.payAd(ad, appdsn,1) />

<!--- <cfset x = claim.updateClaimStatus(statusCode=Status,coopSubmitLineId=655138,dsn=appdsn)> --->
<cfset x = claim.approveStatus(coopSubmitLineId=662860,dsn=appdsn) /> --->

<!--- <cfdump var="#status#" /> --->

<!--- <cfset url.letterSID = "'-> 4YRD" />
<cfset  vars.letterOccuranceID = decrypt(url.letterSID,'htmlCompliance')>
<cfoutput>#vars.letterOccuranceID#</cfoutput> --->

<cfoutput>#(round(((119.99)  * .75) * 100) / 100)#</cfoutput>


