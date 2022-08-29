<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.jivesoftware.openfire.plugin.spark.manager.FileTransferFilterManager" %>
<%@ page import="org.jivesoftware.util.JiveGlobals"%>
<%@ page import="org.jivesoftware.util.ParamUtils" %>
<%@ page import="org.jivesoftware.util.StringUtils" %>
<%@ page import="org.jivesoftware.util.CookieUtils" %>
<%@ page import="org.jivesoftware.openfire.XMPPServer" %>
<%@ page import="org.jivesoftware.openfire.plugin.ClientControlPlugin" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    String accountsEnabledString = JiveGlobals.getProperty("accounts.enabled", "true");
    String addcontactsEnabledString = JiveGlobals.getProperty("addcontacts.enabled", "true");
    String addgroupsEnabledString = JiveGlobals.getProperty("addgroups.enabled", "true");
    String advancedEnabledString = JiveGlobals.getProperty("advanced.enabled", "true");    
    String avatarsEnabledString = JiveGlobals.getProperty("avatars.enabled", "true");
    String broadcastEnabledString = JiveGlobals.getProperty("broadcast.enabled", "true");    
    String removalsEnabledString = JiveGlobals.getProperty("removals.enabled", "true");
    String renamesEnabledString = JiveGlobals.getProperty("renames.enabled", "true");
    String fileTransferEnabledString = JiveGlobals.getProperty("transfer.enabled", "true");    
    String ibbOnlyEnabledString = JiveGlobals.getProperty("ibbonly.enabled", "true");
    String helpforumsEnabledString = JiveGlobals.getProperty("helpforums.enabled", "true");
    String helpuserguideEnabledString = JiveGlobals.getProperty("helpuserguide.enabled", "true");

// If the "history.enabled" property name exists from an older version of Client Control, then:
//  1) Carry over its property value to "History Settings" and "History Transcripts"
//  2) Delete the "history.enabled" property name since it has been superceded

    String oldHistorySettings = JiveGlobals.getProperty("history.enabled");

    if (oldHistorySettings != null) {
        JiveGlobals.setProperty("historysettings.enabled", oldHistorySettings);
        JiveGlobals.setProperty("historytranscripts.enabled", oldHistorySettings);
        JiveGlobals.deleteProperty("history.enabled");
    }

    String historysettingsEnabledString = JiveGlobals.getProperty("historysettings.enabled", "true");
    String historytranscriptsEnabledString = JiveGlobals.getProperty("historytranscripts.enabled", "true");

    String hostnameEnabledString = JiveGlobals.getProperty("hostname.enabled", "true");
    String invisibleloginEnabledString = JiveGlobals.getProperty("invisiblelogin.enabled", "true");
    String anonymousloginEnabledString = JiveGlobals.getProperty("anonymouslogin.enabled", "true");
    String logoutexitEnabledString = JiveGlobals.getProperty("logoutexit.enabled", "true");
    String movecopyEnabledString = JiveGlobals.getProperty("movecopy.enabled", "true");
    String passwordchangeEnabledString = JiveGlobals.getProperty("passwordchange.enabled", "true");
    String personsearchEnabledString = JiveGlobals.getProperty("personsearch.enabled", "true");
    String pluginsEnabledString = JiveGlobals.getProperty("plugins.enabled", "true");
    String preferencesEnabledString = JiveGlobals.getProperty("preferences.enabled", "true");
    String presenceEnabledString = JiveGlobals.getProperty("presence.enabled", "true");
    String vcardEnabledString = JiveGlobals.getProperty("vcard.enabled", "true");    
    String savepassandautologinEnabledString = JiveGlobals.getProperty("savepassandautologin.enabled", "true");
    String updatesEnabledString = JiveGlobals.getProperty("updates.enabled", "true");
    String viewnotesEnabledString = JiveGlobals.getProperty("viewnotes.enabled", "true");
    String viewtasklistEnabledString = JiveGlobals.getProperty("viewtasklist.enabled", "true");
    String startachatEnabledString = JiveGlobals.getProperty("startachat.enabled", "true");
    String hostnameasresourceEnabledString = JiveGlobals.getProperty("hostnameasresource.enabled", "false");
    String versionasresourceEnabledString = JiveGlobals.getProperty("versionasresource.enabled", "false");
    String idleEnabledString = JiveGlobals.getProperty("idle.enabled", "true");

    boolean submit = request.getParameter("submit") != null;

    Cookie csrfCookie = CookieUtils.getCookie(request, "csrf");
    String csrfParam = ParamUtils.getParameter(request, "csrf");
    boolean csrfStatus = true;

    if (submit == true && (csrfCookie == null || csrfParam == null || !csrfCookie.getValue().equals(csrfParam))) {
        submit = false;
        csrfStatus = false;
    }
    csrfParam = StringUtils.randomString(16);
    CookieUtils.setCookie(request, response, "csrf", csrfParam, -1);
    pageContext.setAttribute("csrf", csrfParam);

    if (submit) {
        accountsEnabledString = request.getParameter("accountsEnabled");
        addcontactsEnabledString = request.getParameter("addcontactsEnabled");
        addgroupsEnabledString = request.getParameter("addgroupsEnabled");
        advancedEnabledString = request.getParameter("advancedEnabled");
        avatarsEnabledString = request.getParameter("avatarsEnabled");		
        broadcastEnabledString = request.getParameter("broadcastEnabled");
        removalsEnabledString = request.getParameter("removalsEnabled");
        renamesEnabledString = request.getParameter("renamesEnabled");
        fileTransferEnabledString = request.getParameter("transferEnabled");
        ibbOnlyEnabledString = request.getParameter("ibbOnlyEnabled");
        helpforumsEnabledString = request.getParameter("helpforumsEnabled");
        helpuserguideEnabledString = request.getParameter("helpuserguideEnabled");
        historysettingsEnabledString = request.getParameter("historysettingsEnabled");
        historytranscriptsEnabledString = request.getParameter("historytranscriptsEnabled");
        hostnameEnabledString = request.getParameter("hostnameEnabled");
        invisibleloginEnabledString = request.getParameter("invisibleloginEnabled");
        anonymousloginEnabledString = request.getParameter("anonymousloginEnabled");
        logoutexitEnabledString = request.getParameter("logoutexitEnabled");
        movecopyEnabledString = request.getParameter("movecopyEnabled");
        passwordchangeEnabledString = request.getParameter("passwordchangeEnabled");
        personsearchEnabledString = request.getParameter("personsearchEnabled");
        pluginsEnabledString = request.getParameter("pluginsEnabled");
        preferencesEnabledString = request.getParameter("preferencesEnabled");
        presenceEnabledString = request.getParameter("presenceEnabled");
        vcardEnabledString = request.getParameter("vcardEnabled");
        savepassandautologinEnabledString = request.getParameter("savepassandautologinEnabled");
        updatesEnabledString = request.getParameter("updatesEnabled");
        viewnotesEnabledString = request.getParameter("viewnotesEnabled");
        viewtasklistEnabledString = request.getParameter("viewtasklistEnabled");
        startachatEnabledString = request.getParameter("startachatEnabled");
        hostnameasresourceEnabledString = request.getParameter("hostnameasresourceEnabled");
        versionasresourceEnabledString = request.getParameter("versionasresourceEnabled");
        idleEnabledString = request.getParameter("idleEnabled");

        final List<String> blackListedPlugins = new ArrayList<>();
        if ( !Boolean.parseBoolean( request.getParameter("sparkPluginReversiEnabled")) ) {
            blackListedPlugins.add("Reversi");
        }
        if ( !Boolean.parseBoolean( request.getParameter("sparkPluginTicTacToeEnabled")) ) {
            blackListedPlugins.add("TicTacToe");
        }
		if ( !Boolean.parseBoolean( request.getParameter("sparkPluginTranslatorEnabled")) ) {
            blackListedPlugins.add("TranslatorPlugin");
        }
		if ( !Boolean.parseBoolean( request.getParameter("sparkPluginHttpFileUploadEnabled")) ) {
            blackListedPlugins.add("HttpFileUploadPlugin");
        }
		if ( !Boolean.parseBoolean( request.getParameter("sparkPluginTransferGuardEnabled")) ) {
            blackListedPlugins.add("TransferGuard");
        }
		if ( !Boolean.parseBoolean( request.getParameter("sparkPluginRoarEnabled")) ) {
            blackListedPlugins.add("Roar");
        }
		if ( !Boolean.parseBoolean( request.getParameter("sparkPluginPadeMeetingsEnabled")) ) {
            blackListedPlugins.add("PadeMeetingsPlugin");
        }
				if ( !Boolean.parseBoolean( request.getParameter("sparkPluginFastpathEnabled")) ) {
            blackListedPlugins.add("Fastpath");
        }
				if ( !Boolean.parseBoolean( request.getParameter("sparkPluginWindowFlashingEnabled")) ) {
            blackListedPlugins.add("WindowFlashingPlugin");
        }
		
        JiveGlobals.setProperty("accounts.enabled", accountsEnabledString);
        JiveGlobals.setProperty("addcontacts.enabled", addcontactsEnabledString);
        JiveGlobals.setProperty("addgroups.enabled", addgroupsEnabledString);
        JiveGlobals.setProperty("advanced.enabled", advancedEnabledString);
        JiveGlobals.setProperty("avatars.enabled", avatarsEnabledString);		
        JiveGlobals.setProperty("broadcast.enabled", broadcastEnabledString);
        JiveGlobals.setProperty("removals.enabled", removalsEnabledString);
        JiveGlobals.setProperty("renames.enabled", renamesEnabledString);
        JiveGlobals.setProperty("transfer.enabled", fileTransferEnabledString);
        JiveGlobals.setProperty("ibbonly.enabled", ibbOnlyEnabledString);
        JiveGlobals.setProperty("helpforums.enabled", helpforumsEnabledString);
        JiveGlobals.setProperty("helpuserguide.enabled", helpuserguideEnabledString);
        JiveGlobals.setProperty("historysettings.enabled", historysettingsEnabledString);
        JiveGlobals.setProperty("historytranscripts.enabled", historytranscriptsEnabledString);
        JiveGlobals.setProperty("hostname.enabled", hostnameEnabledString);
        JiveGlobals.setProperty("invisiblelogin.enabled", invisibleloginEnabledString);
        JiveGlobals.setProperty("anonymouslogin.enabled", anonymousloginEnabledString);
        JiveGlobals.setProperty("logoutexit.enabled", logoutexitEnabledString);
        JiveGlobals.setProperty("movecopy.enabled", movecopyEnabledString);
        JiveGlobals.setProperty("passwordchange.enabled", passwordchangeEnabledString);
        JiveGlobals.setProperty("personsearch.enabled", personsearchEnabledString);
        JiveGlobals.setProperty("plugins.enabled", pluginsEnabledString);
        JiveGlobals.setProperty("preferences.enabled", preferencesEnabledString);
        JiveGlobals.setProperty("presence.enabled", presenceEnabledString);
        JiveGlobals.setProperty("vcard.enabled", vcardEnabledString);		
        JiveGlobals.setProperty("savepassandautologin.enabled", savepassandautologinEnabledString);
        JiveGlobals.setProperty("updates.enabled", updatesEnabledString);
        JiveGlobals.setProperty("viewnotes.enabled", viewnotesEnabledString);
        JiveGlobals.setProperty("viewtasklist.enabled", viewtasklistEnabledString);
        JiveGlobals.setProperty("startachat.enabled", startachatEnabledString);
        JiveGlobals.setProperty("hostnameasresource.enabled", hostnameasresourceEnabledString);
        JiveGlobals.setProperty("versionasresource.enabled", versionasresourceEnabledString);
        JiveGlobals.setProperty("sparkplugin.blacklist", blackListedPlugins);
        JiveGlobals.setProperty("idle.enabled", idleEnabledString);
    }
    
    boolean accountsEnabled = Boolean.parseBoolean(accountsEnabledString);
    boolean addcontactsEnabled = Boolean.parseBoolean(addcontactsEnabledString);
    boolean addgroupsEnabled = Boolean.parseBoolean(addgroupsEnabledString);
    boolean advancedEnabled = Boolean.parseBoolean(advancedEnabledString);
    boolean avatarsEnabled = Boolean.parseBoolean(avatarsEnabledString);	
    boolean broadcastEnabled = Boolean.parseBoolean(broadcastEnabledString);
    boolean removalsEnabled = Boolean.parseBoolean(removalsEnabledString);
    boolean renamesEnabled = Boolean.parseBoolean(renamesEnabledString);
    boolean transferEnabled = Boolean.parseBoolean(fileTransferEnabledString);
    boolean ibbOnlyEnabled = Boolean.parseBoolean(ibbOnlyEnabledString);
    boolean helpforumsEnabled = Boolean.parseBoolean(helpforumsEnabledString);
    boolean helpuserguideEnabled = Boolean.parseBoolean(helpuserguideEnabledString);
    boolean historysettingsEnabled = Boolean.parseBoolean(historysettingsEnabledString);
    boolean historytranscriptsEnabled = Boolean.parseBoolean(historytranscriptsEnabledString);
    boolean hostnameEnabled = Boolean.parseBoolean(hostnameEnabledString);
    boolean invisibleloginEnabled = Boolean.parseBoolean(invisibleloginEnabledString);
    boolean anonymousloginEnabled = Boolean.parseBoolean(anonymousloginEnabledString);
    boolean logoutexitEnabled = Boolean.parseBoolean(logoutexitEnabledString);
    boolean movecopyEnabled = Boolean.parseBoolean(movecopyEnabledString);
    boolean passwordchangeEnabled = Boolean.parseBoolean(passwordchangeEnabledString);
    boolean personsearchEnabled = Boolean.parseBoolean(personsearchEnabledString);
    boolean pluginsEnabled = Boolean.parseBoolean(pluginsEnabledString);
    boolean preferencesEnabled = Boolean.parseBoolean(preferencesEnabledString);
    boolean presenceEnabled = Boolean.parseBoolean(presenceEnabledString);
    boolean vcardEnabled = Boolean.parseBoolean(vcardEnabledString);	
    boolean savepassandautologinEnabled = Boolean.parseBoolean(savepassandautologinEnabledString);
    boolean updatesEnabled = Boolean.parseBoolean(updatesEnabledString);
    boolean viewnotesEnabled = Boolean.parseBoolean(viewnotesEnabledString);
    boolean viewtasklistEnabled = Boolean.parseBoolean(viewtasklistEnabledString);
    boolean startachatEnabled = Boolean.parseBoolean(startachatEnabledString);
    boolean hostnameasresourceEnabled = Boolean.parseBoolean(hostnameasresourceEnabledString);
    boolean versionasresourceEnabled = Boolean.parseBoolean(versionasresourceEnabledString);
    boolean idleEnabled = Boolean.parseBoolean(idleEnabledString);

    final List<String> blacklistedPlugins = JiveGlobals.getListProperty("sparkplugin.blacklist", new ArrayList<String>());
    boolean sparkPluginReversiEnabled = !blacklistedPlugins.contains("Reversi");
    boolean sparkPluginTicTacToeEnabled = !blacklistedPlugins.contains("TicTacToe");
	boolean sparkPluginTranslatorEnabled = !blacklistedPlugins.contains("TranslatorPlugin");
	boolean sparkPluginHttpFileUploadEnabled = !blacklistedPlugins.contains("HttpFileUploadPlugin");
	boolean sparkPluginTransferGuardEnabled = !blacklistedPlugins.contains("TransferGuard");
	boolean sparkPluginRoarEnabled = !blacklistedPlugins.contains("Roar");
	boolean sparkPluginPadeMeetingsEnabled = !blacklistedPlugins.contains("PadeMeetingsPlugin");
	boolean sparkPluginFastpathEnabled = !blacklistedPlugins.contains("Fastpath");
	boolean sparkPluginWindowFlashingEnabled = !blacklistedPlugins.contains("WindowFlashingPlugin");
	
    // Enable File Transfer in the system.
    ClientControlPlugin plugin = (ClientControlPlugin) XMPPServer.getInstance()
            .getPluginManager().getPlugin("clientcontrol");
    FileTransferFilterManager manager = plugin.getFileTransferFilterManager();
    manager.enableFileTransfer(transferEnabled);
%>

<html>
<head>
    <title><fmt:message key="client.features.title"/></title>
    <meta name="pageID" content="client-features"/>
    <style type="text/css">
        @import "style/style.css";
    </style>
</head>

<body>


<% if (submit) { %>

<div class="success">
  <fmt:message key="client.features.update.features"/>
</div>
<br>
<% }%>
<% if (csrfStatus == false) { %>
    <admin:infobox type="error"><fmt:message key="global.csrf.failed" /></admin:infobox>
<% } %>
<p>
    <fmt:message key="client.features.info"/>
</p>

<form name="f" action="client-features.jsp" method="post">
    <input type="hidden" name="csrf" value="${csrf}">
    <div style="display:inline-block;width:600px;margin:10px;">
        <table class="jive-table" cellspacing="0" width="600" >
            <th><fmt:message key="client.feature"/></th>
            <th><fmt:message key="client.features.enabled"/></th>
            <th><fmt:message key="client.features.disabled"/></th>
            <tr>
                <td><b><fmt:message key="client.features.accounts" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.accounts.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="accountsEnabled" value="true" <%= accountsEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="accountsEnabled" value="false" <%= !accountsEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.addcontacts" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.addcontacts.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="addcontactsEnabled" value="true" <%= addcontactsEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="addcontactsEnabled" value="false" <%= !addcontactsEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.addgroups" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.addgroups.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="addgroupsEnabled" value="true" <%= addgroupsEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="addgroupsEnabled" value="false" <%= !addgroupsEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.advanced" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.advanced.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="advancedEnabled" value="true" <%= advancedEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="advancedEnabled" value="false" <%= !advancedEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.avatars" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.avatars.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="avatarsEnabled" value="true" <%= avatarsEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="avatarsEnabled" value="false" <%= !avatarsEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.broadcasting" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                  <fmt:message key="client.features.broadcasting.description" />
               </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="broadcastEnabled" value="true" <%= broadcastEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="broadcastEnabled" value="false" <%= !broadcastEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.removals" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.removals.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="removalsEnabled" value="true" <%= removalsEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="removalsEnabled" value="false" <%= !removalsEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.renames" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.renames.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="renamesEnabled" value="true" <%= renamesEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="renamesEnabled" value="false" <%= !renamesEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.startachat" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                   <fmt:message key="client.features.startachat.description" />
               </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="startachatEnabled" value="true" <%= startachatEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="startachatEnabled" value="false" <%= !startachatEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.transfer" /></b> - <fmt:message key="client.features.otherclients" /><br/><span class="jive-description">
                   <fmt:message key="client.features.transfer.description" />
               </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="transferEnabled" value="true" <%= transferEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="transferEnabled" value="false" <%= !transferEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.ibbonly" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                   <fmt:message key="client.features.ibbonly.description" />
               </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="ibbOnlyEnabled" value="true" <%= ibbOnlyEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="ibbOnlyEnabled" value="false" <%= !ibbOnlyEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.helpforums" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                   <fmt:message key="client.features.helpforums.description" />
               </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="helpforumsEnabled" value="true" <%= helpforumsEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="helpforumsEnabled" value="false" <%= !helpforumsEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.helpuserguide" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                   <fmt:message key="client.features.helpuserguide.description" />
               </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="helpuserguideEnabled" value="true" <%= helpuserguideEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="helpuserguideEnabled" value="false" <%= !helpuserguideEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.historysettings" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                   <fmt:message key="client.features.historysettings.description" />
               </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="historysettingsEnabled" value="true" <%= historysettingsEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="historysettingsEnabled" value="false" <%= !historysettingsEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.historytranscripts" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                   <fmt:message key="client.features.historytranscripts.description" />
               </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="historytranscriptsEnabled" value="true" <%= historytranscriptsEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="historytranscriptsEnabled" value="false" <%= !historytranscriptsEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.hostname" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                   <fmt:message key="client.features.hostname.description" />
               </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="hostnameEnabled" value="true" <%= hostnameEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="hostnameEnabled" value="false" <%= !hostnameEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.invisiblelogin" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.invisiblelogin.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="invisibleloginEnabled" value="true" <%= invisibleloginEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="invisibleloginEnabled" value="false" <%= !invisibleloginEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.anonymouslogin" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.anonymouslogin.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="anonymousloginEnabled" value="true" <%= anonymousloginEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="anonymousloginEnabled" value="false" <%= !anonymousloginEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.logoutexit" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.logoutexit.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="logoutexitEnabled" value="true" <%= logoutexitEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="logoutexitEnabled" value="false" <%= !logoutexitEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.movecopy" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.movecopy.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="movecopyEnabled" value="true" <%= movecopyEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="movecopyEnabled" value="false" <%= !movecopyEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.passwordchange" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.passwordchange.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="passwordchangeEnabled" value="true" <%= passwordchangeEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="passwordchangeEnabled" value="false" <%= !passwordchangeEnabled ? "checked" : "" %> />
                </td>
            </tr>
		</table>
    </div>
            
<!-- ======================================================  N E W   T A B L E   H E R E  ====================================================== -->	        
            
    <div style="display:inline-block;width:600px;margin:10px;">
        <table class="jive-table" cellspacing="0" width="600">
            <th><fmt:message key="client.feature"/></th>
            <th><fmt:message key="client.features.enabled"/></th>
            <th><fmt:message key="client.features.disabled"/></th>
            <tr>
                <td><b><fmt:message key="client.features.personsearch" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.personsearch.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="personsearchEnabled" value="true" <%= personsearchEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="personsearchEnabled" value="false" <%= !personsearchEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.plugins" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.plugins.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="pluginsEnabled" value="true" <%= pluginsEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="pluginsEnabled" value="false" <%= !pluginsEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.preferences" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.preferences.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="preferencesEnabled" value="true" <%= preferencesEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="preferencesEnabled" value="false" <%= !preferencesEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.presence" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.presence.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="presenceEnabled" value="true" <%= presenceEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="presenceEnabled" value="false" <%= !presenceEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.vcard" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.vcard.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="vcardEnabled" value="true" <%= vcardEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="vcardEnabled" value="false" <%= !vcardEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.savepassandautologin" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.savepassandautologin.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="savepassandautologinEnabled" value="true" <%= savepassandautologinEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="savepassandautologinEnabled" value="false" <%= !savepassandautologinEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.updates" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.updates.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="updatesEnabled" value="true" <%= updatesEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="updatesEnabled" value="false" <%= !updatesEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.viewnotes" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.viewnotes.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="viewnotesEnabled" value="true" <%= viewnotesEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="viewnotesEnabled" value="false" <%= !viewnotesEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.viewtasklist" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.viewtasklist.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="viewtasklistEnabled" value="true" <%= viewtasklistEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="viewtasklistEnabled" value="false" <%= !viewtasklistEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.hostnameasresource" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.hostnameasresource.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="hostnameasresourceEnabled" value="true" <%= hostnameasresourceEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="hostnameasresourceEnabled" value="false" <%= !hostnameasresourceEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.versionasresource" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.versionasresource.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="versionasresourceEnabled" value="true" <%= versionasresourceEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="versionasresourceEnabled" value="false" <%= !versionasresourceEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.idle" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.idle.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="idleEnabled" value="true" <%= idleEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="idleEnabled" value="false" <%= !idleEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.sparkPluginReversiEnabled" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.sparkPluginReversiEnabled.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginReversiEnabled" value="true" <%= sparkPluginReversiEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginReversiEnabled" value="false" <%= !sparkPluginReversiEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.sparkPluginTicTacToeEnabled" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.sparkPluginTicTacToeEnabled.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginTicTacToeEnabled" value="true" <%= sparkPluginTicTacToeEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginTicTacToeEnabled" value="false" <%= !sparkPluginTicTacToeEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.sparkPluginTranslatorEnabled" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.sparkPluginTranslatorEnabled.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginTranslatorEnabled" value="true" <%= sparkPluginTranslatorEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginTranslatorEnabled" value="false" <%= !sparkPluginTranslatorEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.sparkPluginHttpFileUploadEnabled" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.sparkPluginHttpFileUploadEnabled.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginHttpFileUploadEnabled" value="true" <%= sparkPluginHttpFileUploadEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginHttpFileUploadEnabled" value="false" <%= !sparkPluginHttpFileUploadEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.sparkPluginTransferGuardEnabled" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.sparkPluginTransferGuardEnabled.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginTransferGuardEnabled" value="true" <%= sparkPluginTransferGuardEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginTransferGuardEnabled" value="false" <%= !sparkPluginTransferGuardEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.sparkPluginRoarEnabled" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.sparkPluginRoarEnabled.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginRoarEnabled" value="true" <%= sparkPluginRoarEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginRoarEnabled" value="false" <%= !sparkPluginRoarEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.sparkPluginPadeMeetingsEnabled" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.sparkPluginPadeMeetingsEnabled.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginPadeMeetingsEnabled" value="true" <%= sparkPluginPadeMeetingsEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginPadeMeetingsEnabled" value="false" <%= !sparkPluginPadeMeetingsEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.sparkPluginFastpathEnabled" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.sparkPluginFastpathEnabled.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginFastpathEnabled" value="true" <%= sparkPluginFastpathEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginFastpathEnabled" value="false" <%= !sparkPluginFastpathEnabled ? "checked" : "" %> />
                </td>
            </tr>
            <tr>
                <td><b><fmt:message key="client.features.sparkPluginWindowFlashingEnabled" /></b> - <fmt:message key="client.features.spark.only" /><br/><span class="jive-description">
                         <fmt:message key="client.features.sparkPluginWindowFlashingEnabled.description" />
                      </span></td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginWindowFlashingEnabled" value="true" <%= sparkPluginWindowFlashingEnabled ? "checked" : "" %> />
                </td>
                <td width="1%" nowrap>
                    <input type="radio" name="sparkPluginWindowFlashingEnabled" value="false" <%= !sparkPluginWindowFlashingEnabled ? "checked" : "" %> />
                </td>
            </tr>
        </table>
    </div>

    <br/>
    <input type="submit" name="submit" value="<fmt:message key="client.features.save.settings" />" />
</form>
</body>
</html>
