/**
 * $RCSfile$
 * $Revision: $
 * $Date: $
 *
 * Copyright (C) 2006 Jive Software. All rights reserved.
 *
 * This software is published under the terms of the GNU Public License (GPL),
 * a copy of which is included in this distribution.
 */

package org.jivesoftware.admin;

import org.dom4j.*;
import org.dom4j.io.OutputFormat;
import org.jivesoftware.util.JiveGlobals;
import org.jivesoftware.util.Log;
import org.jivesoftware.util.XMLWriter;

import java.io.IOException;
import java.io.StringWriter;

/**
 * Bean that stores the vcard mapping. It is also responsible for saving the mapping
 * as an XML property and retrieving it.
 *
 * @author Gaston Dombiak
 */
public class LdapUserProfile {

    private String name = "";
    private String email = "";
    private String fullName = "";
    private String nickname = "";
    private String birthday = "";
    private String homeStreet = "";
    private String homeCity = "";
    private String homeState = "";
    private String homeZip = "";
    private String homeCountry = "";
    private String homePhone = "";
    private String homeMobile = "";
    private String homeFax = "";
    private String homePager = "";
    private String businessStreet = "";
    private String businessCity = "";
    private String businessState = "";
    private String businessZip = "";
    private String businessCountry = "";
    private String businessJobTitle = "";
    private String businessDepartment = "";
    private String businessPhone = "";
    private String businessMobile = "";
    private String businessFax = "";
    private String businessPager = "";
    private String businessWebPage = "";

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getHomeStreet() {
        return homeStreet;
    }

    public void setHomeStreet(String homeStreet) {
        this.homeStreet = homeStreet;
    }

    public String getHomeCity() {
        return homeCity;
    }

    public void setHomeCity(String homeCity) {
        this.homeCity = homeCity;
    }

    public String getHomeState() {
        return homeState;
    }

    public void setHomeState(String homeState) {
        this.homeState = homeState;
    }

    public String getHomeZip() {
        return homeZip;
    }

    public void setHomeZip(String homeZip) {
        this.homeZip = homeZip;
    }

    public String getHomeCountry() {
        return homeCountry;
    }

    public void setHomeCountry(String homeCountry) {
        this.homeCountry = homeCountry;
    }

    public String getHomePhone() {
        return homePhone;
    }

    public void setHomePhone(String homePhone) {
        this.homePhone = homePhone;
    }

    public String getHomeMobile() {
        return homeMobile;
    }

    public void setHomeMobile(String homeMobile) {
        this.homeMobile = homeMobile;
    }

    public String getHomeFax() {
        return homeFax;
    }

    public void setHomeFax(String homeFax) {
        this.homeFax = homeFax;
    }

    public String getHomePager() {
        return homePager;
    }

    public void setHomePager(String homePager) {
        this.homePager = homePager;
    }

    public String getBusinessStreet() {
        return businessStreet;
    }

    public void setBusinessStreet(String businessStreet) {
        this.businessStreet = businessStreet;
    }

    public String getBusinessCity() {
        return businessCity;
    }

    public void setBusinessCity(String businessCity) {
        this.businessCity = businessCity;
    }

    public String getBusinessState() {
        return businessState;
    }

    public void setBusinessState(String businessState) {
        this.businessState = businessState;
    }

    public String getBusinessZip() {
        return businessZip;
    }

    public void setBusinessZip(String businessZip) {
        this.businessZip = businessZip;
    }

    public String getBusinessCountry() {
        return businessCountry;
    }

    public void setBusinessCountry(String businessCountry) {
        this.businessCountry = businessCountry;
    }

    public String getBusinessJobTitle() {
        return businessJobTitle;
    }

    public void setBusinessJobTitle(String businessJobTitle) {
        this.businessJobTitle = businessJobTitle;
    }

    public String getBusinessDepartment() {
        return businessDepartment;
    }

    public void setBusinessDepartment(String businessDepartment) {
        this.businessDepartment = businessDepartment;
    }

    public String getBusinessPhone() {
        return businessPhone;
    }

    public void setBusinessPhone(String businessPhone) {
        this.businessPhone = businessPhone;
    }

    public String getBusinessMobile() {
        return businessMobile;
    }

    public void setBusinessMobile(String businessMobile) {
        this.businessMobile = businessMobile;
    }

    public String getBusinessFax() {
        return businessFax;
    }

    public void setBusinessFax(String businessFax) {
        this.businessFax = businessFax;
    }

    public String getBusinessPager() {
        return businessPager;
    }

    public void setBusinessPager(String businessPager) {
        this.businessPager = businessPager;
    }

    public String getBusinessWebPage() {
        return businessWebPage;
    }

    public void setBusinessWebPage(String businessWebPage) {
        this.businessWebPage = businessWebPage;
    }

    /**
     * Sets default mapping values when using an Active Directory server.
     */
    public void initForActiveDirectory() {
        name = "{cn}";
        email = "{mail}";
        fullName = "{displayName}";
        nickname = "";
        birthday = "";
        homeStreet = "{homePostalAddress}";
        homeCity = "";
        homeState = "";
        homeZip = "{homeZip}";
        homeCountry = "{countryCode}";
        homePhone = "{homePhone}";
        homeMobile = "";
        homeFax = "";
        homePager = "";
        businessStreet = "{postalAddress}";
        businessCity = "{l}";
        businessState = "{st}";
        businessZip = "{postalCode}";
        businessCountry = "{countryCode}";
        businessJobTitle = "{title}";
        businessDepartment = "{department}";
        businessPhone = "{otherTelephone}";
        businessMobile = "{mobile}";
        businessFax = "{facsimileTelephoneNumber}";
        businessPager = "{pager}";
        businessWebPage = "";
    }

    /**
     * Sets default mapping values when using an Active Directory server.
     */
    public void initForOpenLDAP() {
        name = "{cn}";
        email = "{mail}";
        fullName = "{displayName}";
        nickname = "{uid}";
        birthday = "";
        homeStreet = "{homePostalAddress}";
        homeCity = "";
        homeState = "";
        homeZip = "";
        homeCountry = "";
        homePhone = "{homePhone}";
        homeMobile = "";
        homeFax = "";
        homePager = "";
        businessStreet = "{postalAddress}";
        businessCity = "{l}";
        businessState = "{st}";
        businessZip = "{postalCode}";
        businessCountry = "";
        businessJobTitle = "{title}";
        businessDepartment = "{departmentNumber}";
        businessPhone = "{telephoneNumber}";
        businessMobile = "{mobile}";
        businessFax = "";
        businessPager = "{pager}";
        businessWebPage = "";
    }

    /**
     * Saves current configuration as XML properties.
     */
    public void saveProperties() {
        Element vCard = DocumentHelper.createElement(QName.get("vCard", "vcard-temp"));
        Element subelement;

        // Add name
        if (name != null && name.trim().length() > 0) {
            subelement = vCard.addElement("N");
            subelement.addElement("GIVEN").setText(name.trim());
        }
        // Add email
        if (email != null && email.trim().length() > 0) {
            subelement = vCard.addElement("EMAIL");
            subelement.addElement("INTERNET");
            subelement.addElement("USERID").setText(email.trim());
        }
        // Add Full Name
        vCard.addElement("FN").setText(fullName.trim());
        // Add nickname
        if (nickname != null && nickname.trim().length() > 0) {
            vCard.addElement("NICKNAME").setText(nickname.trim());
        }
        // Add birthday
        if (birthday != null && birthday.trim().length() > 0) {
            vCard.addElement("BDAY").setText(birthday.trim());
        }
        // Add home address
        subelement = vCard.addElement("ADR");
        subelement.addElement("HOME");
        if (homeStreet != null && homeStreet.trim().length() > 0) {
            subelement.addElement("STREET").setText(homeStreet.trim());
        }
        if (homeCity != null && homeCity.trim().length() > 0) {
            subelement.addElement("LOCALITY").setText(homeCity.trim());
        }
        if (homeState != null && homeState.trim().length() > 0) {
            subelement.addElement("REGION").setText(homeState.trim());
        }
        if (homeZip != null && homeZip.trim().length() > 0) {
            subelement.addElement("PCODE").setText(homeZip.trim());
        }
        if (homeCountry != null && homeCountry.trim().length() > 0) {
            subelement.addElement("CTRY").setText(homeCountry.trim());
        }
        // Add business address
        subelement = vCard.addElement("ADR");
        subelement.addElement("WORK");
        if (businessStreet != null && businessStreet.trim().length() > 0) {
            subelement.addElement("STREET").setText(businessStreet.trim());
        }
        if (businessCity != null && businessCity.trim().length() > 0) {
            subelement.addElement("LOCALITY").setText(businessCity.trim());
        }
        if (businessState != null && businessState.trim().length() > 0) {
            subelement.addElement("REGION").setText(businessState.trim());
        }
        if (businessZip != null && businessZip.trim().length() > 0) {
            subelement.addElement("PCODE").setText(homeZip.trim());
        }
        if (businessCountry != null && businessCountry.trim().length() > 0) {
            subelement.addElement("CTRY").setText(businessCountry.trim());
        }
        // Add home phone
        if (homePhone != null && homePhone.trim().length() > 0) {
            subelement = vCard.addElement("TEL");
            subelement.addElement("HOME");
            subelement.addElement("VOICE");
            subelement.addElement("NUMBER").setText(homePhone.trim());
        }
        // Add home mobile
        if (homeMobile != null && homeMobile.trim().length() > 0) {
            subelement = vCard.addElement("TEL");
            subelement.addElement("HOME");
            subelement.addElement("VOICE");
            subelement.addElement("CELL");
            subelement.addElement("NUMBER").setText(homeMobile.trim());
        }
        // Add home fax
        if (homeFax != null && homeFax.trim().length() > 0) {
            subelement = vCard.addElement("TEL");
            subelement.addElement("HOME");
            subelement.addElement("FAX");
            subelement.addElement("NUMBER").setText(homeFax.trim());
        }
        // Add home pager
        if (homePager != null && homePager.trim().length() > 0) {
            subelement = vCard.addElement("TEL");
            subelement.addElement("HOME");
            subelement.addElement("PAGER");
            subelement.addElement("NUMBER").setText(homePager.trim());
        }
        // Add business phone
        if (businessPhone != null && businessPhone.trim().length() > 0) {
            subelement = vCard.addElement("TEL");
            subelement.addElement("WORK");
            subelement.addElement("VOICE");
            subelement.addElement("NUMBER").setText(businessPhone.trim());
        }
        // Add business mobile
        if (businessMobile != null && businessMobile.trim().length() > 0) {
            subelement = vCard.addElement("TEL");
            subelement.addElement("WORK");
            subelement.addElement("VOICE");
            subelement.addElement("CELL");
            subelement.addElement("NUMBER").setText(businessMobile.trim());
        }
        // Add business fax
        if (businessFax != null && businessFax.trim().length() > 0) {
            subelement = vCard.addElement("TEL");
            subelement.addElement("WORK");
            subelement.addElement("FAX");
            subelement.addElement("NUMBER").setText(businessFax.trim());
        }
        // Add business pager
        if (businessPager != null && businessPager.trim().length() > 0) {
            subelement = vCard.addElement("TEL");
            subelement.addElement("WORK");
            subelement.addElement("PAGER");
            subelement.addElement("NUMBER").setText(businessPager.trim());
        }
        // Add job title
        if (businessJobTitle != null && businessJobTitle.trim().length() > 0) {
            vCard.addElement("TITLE").setText(businessJobTitle.trim());
        }
        // TODO Add job department
        // TODO Add web page

        // Generate content to store in property
        String vcardXML;
        StringWriter writer = new StringWriter();
        OutputFormat prettyPrinter = OutputFormat.createPrettyPrint();
        XMLWriter xmlWriter = new XMLWriter(writer, prettyPrinter);
        try {
            xmlWriter.write(vCard);
            vcardXML = writer.toString();
        }
        catch (IOException e) {
            Log.error("Error pretty formating XML", e);
            vcardXML = vCard.asXML();
        }

        StringBuilder sb = new StringBuilder(vcardXML.length());
        sb.append("<![CDATA[").append(vcardXML).append("]]>");
        // Save mapping as an XML property
        JiveGlobals.setXMLProperty("ldap.vcard-mapping", sb.toString());
    }

    /**
     * Returns true if the vCard mappings where successfully loaded from the XML
     * property.
     *
     * @return true if mappings where loaded from saved property.
     */
    public boolean loadFromProperties() {
        String xmlProperty = JiveGlobals.getXMLProperty("ldap.vcard-mapping");
        if (xmlProperty == null || xmlProperty.trim().length() == 0) {
            return false;
        }

        try {
            Document document = DocumentHelper.parseText(xmlProperty);
            Element vCard = document.getRootElement();

            Element element = vCard.element("N");
            if (element != null) {
                name = element.elementTextTrim("GIVEN");
            }
            element = vCard.element("EMAIL");
            if (element != null) {
                email = element.elementTextTrim("USERID");
            }
            element = vCard.element("FN");
            if (element != null) {
                fullName = vCard.getTextTrim();
            }
            element = vCard.element("NICKNAME");
            if (element != null) {
                nickname = vCard.getTextTrim();
            }
            element = vCard.element("BDAY");
            if (element != null) {
                birthday = vCard.getTextTrim();
            }
            // TODO add rest of fields
        }
        catch (DocumentException e) {
            Log.error("Error loading vcard mappings from property", e);
            return false;
        }

        return true;
    }
}