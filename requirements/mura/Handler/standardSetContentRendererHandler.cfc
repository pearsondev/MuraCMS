<cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	
	<cfset event.setValue('contentRenderer',createObject("component","#application.configBean.getWebRootMap()#.#event.getValue('siteid')#.includes.contentRenderer").init(event))/>

</cffunction>

</cfcomponent>