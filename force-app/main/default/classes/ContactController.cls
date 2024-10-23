public with sharing class ContactController {
    /* Gets a list of contacts in the system. */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [
            SELECT
                Id,
                Name,
                FirstName,
                LastName,
                Title,
                Phone,
                Email,
                Picture__c
            FROM Contact
            WHERE Picture__c != NULL
            WITH USER_MODE
            LIMIT 10
        ];
    }

    /* This method returns a list of contacts that match the specified key. */
    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WHERE Name LIKE :key AND Picture__c != NULL
            WITH USER_MODE
            LIMIT 10
        ];
    }

    /* This method returns a single contact that has a user mode. */
    @AuraEnabled(cacheable=true)
    public static Contact getSingleContact() {
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WITH USER_MODE
            LIMIT 1
        ];
    }

    /* Update the contacts in the database. */
    @AuraEnabled
    public static void updateContacts(List<Contact> contactsForUpdate) {
        // Make sure we can update the database before trying to update
        if (!Schema.sObjectType.Contact.isUpdateable()) {
            throw new SecurityException(
                'Insufficient permissions to update contacts'
            );
        }
        update contactsForUpdate;
    }

    /* Method updateContact. */
    @AuraEnabled
    public static void updateContact(
        Id recordId,
        String firstName,
        String lastName
    ) {
        Contact contact = new Contact(
            Id = recordId,
            FirstName = firstName,
            LastName = lastName
        );
        update contact;
    }
}
