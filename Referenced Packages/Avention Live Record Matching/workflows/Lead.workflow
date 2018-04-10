<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>iSell_LiveRecordMatching_Lead_OM</fullName>
        <apiVersion>22.0</apiVersion>
        <description>iSell_LiveRecordMatching_Lead_OM Outbound Message used for LiveMatching</description>
        <endpointUrl>https://isell4crm.onesource.com/Web/Register/LeadNotificationService.asmx</endpointUrl>
        <fields>City</fields>
        <fields>Company</fields>
        <fields>Country</fields>
        <fields>Id</fields>
        <fields>Phone</fields>
        <fields>PostalCode</fields>
        <fields>State</fields>
        <fields>Street</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ayoshikawa@demandblue.com</integrationUser>
        <name>iSell_LiveRecordMatching_Lead_OM</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
</Workflow>
