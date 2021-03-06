<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfreturn this />
</cffunction>

<cffunction name="getCategories" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String">
	<cfargument name="parentID" type="String">
	<cfargument name="keywords"  type="string" required="true" default=""/>
	<cfargument name="activeOnly" type="boolean" required="true" default="false">
	<cfargument name="InterestsOnly" type="boolean" required="true" default="false">
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select tcontentcategories.categoryID,tcontentcategories.name,tcontentcategories.parentID,tcontentcategories.isActive,tcontentcategories.isInterestGroup,tcontentcategories.isOpen, count(tcontentcategories2.parentid) as hasKids 
	,tcontentcategories.restrictGroups from 
	tcontentcategories left join tcontentcategories tcontentcategories2 ON
	(tcontentcategories.categoryID = tcontentcategories2.parentID)
	where tcontentcategories.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and tcontentcategories.parentID <cfif arguments.parentID neq ''> = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#" /><cfelse> is null </cfif>
	<cfif arguments.keywords neq ''>and tcontentcategories.name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%" /></cfif> 
	<cfif arguments.activeOnly>and tcontentcategories.isActive=1</cfif>
	<cfif arguments.InterestsOnly>and tcontentcategories.isInterestGroup=1</cfif>
	group by tcontentcategories.categoryID,tcontentcategories.name,tcontentcategories.parentID,tcontentcategories.isActive,tcontentcategories.isInterestGroup,tcontentcategories.isOpen,tcontentcategories.restrictGroups
	order by tcontentcategories.name
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getInterestGroupCount" access="public" output="false" returntype="numeric">
	<cfargument name="siteID" type="String">
	<cfargument name="activeOnly" type="boolean" required="true" default="false">
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select count(*) as theCount from tcontentcategories
	where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and isInterestGroup=1
	<cfif arguments.activeOnly>
	and isactive=1
	</cfif>
	</cfquery>
	
	<cfreturn rs.theCount />
</cffunction>

<cffunction name="getCategoryCount" access="public" output="false" returntype="numeric">
	<cfargument name="siteID" type="String">
	<cfargument name="activeOnly" type="boolean" required="true" default="false">
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select count(*) as theCount from tcontentcategories
	where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	<cfif arguments.activeOnly>
	and isactive=1
	</cfif>
	</cfquery>
	
	<cfreturn rs.theCount />
</cffunction>

<cffunction name="getCategoriesBySiteID" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String">
	<cfargument name="keywords"  type="string" required="true" default=""/>
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tcontentcategories where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	<cfif arguments.keywords neq ''>and tcontentcategories.name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%" /></cfif> 
	order by name
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getInterestGroupsBySiteID" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String">
	<cfargument name="keywords"  type="string" required="true" default=""/>
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tcontentcategories where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and isInterestGroup=1
	<cfif arguments.keywords neq ''>and tcontentcategories.name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%" /></cfif> 
	order by name
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getCategoryfeatures" access="public" output="false" returntype="query">
	<cfargument name="categoryBean" type="any">
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select tcontent.title, tcontent.releasedate, tcontent.menuTitle, tcontent.lastupdate, tcontent.summary, 
	tcontent.filename, tcontent.type, tcontent.contentid, tcontent.target, tcontent.targetParams, 							
	tcontent.restricted, tcontent.restrictgroups, tcontent.displaystart, tcontent.displaystop, 0 as comments,
	tcontentcategoryassign.orderno,tcontent.display,tcontent.active,tcontent.approved,tcontentcategoryassign.featureStart,tcontentcategoryassign.featureStop,
	tcontentcategoryassign.isFeature,tfiles.fileSize,tfiles.fileExt, tcontent.fileID, tcontent.fileID, tcontent.credits,
	tcontent.remoteSource, tcontent.remoteURL, tcontent.remoteSourceURL, tcontent.Audience, tcontent.keyPoints
	from tcontent inner join tcontentcategoryassign 
	ON (tcontent.contenthistid=tcontentcategoryassign.contenthistID)
	Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
	where 
	tcontent.active=1
	and tcontentcategoryassign.isFeature > 0
	and tcontentcategoryassign.categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryBean.getCategoryID()#" />
	order by 
	<cfif arguments.categoryBean.getSortBy() neq 'orderno'>
		tcontent.#arguments.categoryBean.getSortBy()# #arguments.categoryBean.getSortDirection()#
	<cfelse>
	tcontentcategoryassign.#arguments.categoryBean.getSortBy()# #arguments.categoryBean.getSortDirection()#
	</cfif>
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getLiveCategoryfeatures" access="public" output="false" returntype="query">
	<cfargument name="categoryBean" type="any">
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select tcontent.title, tcontent.releasedate, tcontent.menuTitle, tcontent.lastupdate, tcontent.summary, 
	tcontent.filename, tcontent.type, tcontent.contentid, tcontent.target, tcontent.targetParams, 							
	tcontent.restricted, tcontent.restrictgroups, tcontent.displaystart, tcontent.displaystop, 0 as comments,
	tcontentcategoryassign.orderno,tcontent.display,tcontent.active,tcontent.approved,tcontentcategoryassign.featureStart,tcontentcategoryassign.featureStop,
	tcontentcategoryassign.isFeature, tfiles.fileSize,tfiles.fileExt,tcontent.fileID, tcontent.credits,
	tcontent.remoteSource, tcontent.remoteURL, tcontent.remoteSourceURL, tcontent.Audience, tcontent.keyPoints
	from tcontent inner join tcontentcategoryassign 
	ON (tcontent.contenthistid=tcontentcategoryassign.contenthistID) 
	Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
	where 
	tcontent.active=1
	and tcontentcategoryassign.categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryBean.getCategoryID()#" />
	
	 AND 
	 

	 (tcontent.Display=1
	 
	 or
	 
	tcontent.Display = 2 
	
	and tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND  (tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> or tcontent.DisplayStop is null)
	
	)
	
	and 
	
	 (tcontentcategoryassign.isFeature=1
	 
	 or
	 
	tcontentcategoryassign.isFeature = 2 
	
	and tcontentcategoryassign.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND  (tcontentcategoryassign.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> or tcontentcategoryassign.FeatureStop is null)
	
	)
			 
		 
	
	order by
	<cfif arguments.categoryBean.getSortBy() neq 'orderno'>
		tcontent.#arguments.categoryBean.getSortBy()# #arguments.categoryBean.getSortDirection()#
	<cfelse>
	tcontentcategoryassign.#arguments.categoryBean.getSortBy()# #arguments.categoryBean.getSortDirection()#
	</cfif>
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getPrivateInterestGroups" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />
	<cfargument name="parentid" type="string" default="" />
	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT tsettings.Site, tcontentcategories.categoryID, tcontentcategories.name,tcontentcategories.isOpen,
	count(tcontentcategories2.parentid) as hasKids
	FROM tsettings INNER JOIN tcontentcategories ON tsettings.SiteID = tcontentcategories.SiteID
	left join tcontentcategories tcontentcategories2 ON(
	tcontentcategories.categoryID = tcontentcategories2.parentID)
	WHERE tcontentcategories.isInterestGroup=1
	and tcontentcategories.parentID <cfif arguments.parentID neq ''> = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#" /><cfelse> is null </cfif>
	and tsettings.PrivateUserPoolID = '#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
	group by  tsettings.Site, tcontentcategories.categoryID, tcontentcategories.name,tcontentcategories.isOpen
	ORDER BY tsettings.Site, tcontentcategories.name
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="getPublicInterestGroups" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />
	<cfargument name="parentid" type="string" default="" />
	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT tsettings.Site, tcontentcategories.categoryID, tcontentcategories.name,tcontentcategories.isOpen,
	count(tcontentcategories2.parentid) as hasKids
	FROM tsettings INNER JOIN tcontentcategories ON tsettings.SiteID = tcontentcategories.SiteID
	left join tcontentcategories tcontentcategories2 ON(
	tcontentcategories.categoryID = tcontentcategories2.parentID)
	WHERE tcontentcategories.isInterestGroup =1 
	and tcontentcategories.parentID <cfif arguments.parentID neq ''> = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#" /><cfelse> is null </cfif>
	and tsettings.PublicUserPoolID = '#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
	group by  tsettings.Site, tcontentcategories.categoryID, tcontentcategories.name,tcontentcategories.isOpen
	ORDER BY tsettings.Site, tcontentcategories.name
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="getCrumbQuery" output="false" returntype="any">
	<cfargument name="path" required="true">
	<cfargument name="siteID" required="true">
	<cfargument name="sort" required="true" default="asc">
	<cfset var rs="">
		
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select categoryID,siteID,dateCreated,lastUpdate,lastUpdateBy,name,isInterestGroup,parentID,isActive,isOpen,notes,sortBy,sortDirection,restrictGroups,path,remoteID,remoteSourceURL,remotePubDate, 
		<cfif variables.configBean.getDBType() eq "MSSQL">
		len(Cast(path as varchar(1000))) depth
		<cfelse>
		length(path) depth
		</cfif> 
		from tcontentcategories where 
		categoryID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.path#">)
		and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteIDs#"/>
		order by depth <cfif arguments.sort eq "desc">desc<cfelse>asc</cfif>
	</cfquery>	
	
	<cfreturn rs>
</cffunction>
</cfcomponent>