<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>iSell_LiveRecordMatching_Account_OM</fullName>
        <apiVersion>22.0</apiVersion>
        <description>AccountOSOM Outbound Message used for LiveMatching</description>
        <endpointUrl>https://isell4crm.onesource.com/Web/Register/AccountNotificationService.asmx</endpointUrl>
        <fields>BillingCity</fields>
        <fields>BillingCountry</fields>
        <fields>BillingPostalCode</fields>
        <fields>BillingState</fields>
        <fields>BillingStreet</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>Phone</fields>
        <fields>ShippingCity</fields>
        <fields>ShippingCountry</fields>
        <fields>ShippingPostalCode</fields>
        <fields>ShippingState</fields>
        <fields>ShippingStreet</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ayoshikawa@demandblue.com</integrationUser>
        <name>iSell_LiveRecordMatching_Account_OM</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
</Workflow>
