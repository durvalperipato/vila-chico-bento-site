# Security Rules & Multi-Tenant Isolation

This document defines access control policies for Cloud Firestore and Firebase Storage to guarantee each client operates strictly within the scope of their assigned website identifier (`siteId`).

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Public read access for published site content by any visitor
    // Write access restricted to authenticated operators matching the siteId token
    match /sites/{siteId} {
      allow read: if true;
      allow write: if request.auth != null 
                   && (request.auth.token.siteId == siteId || request.auth.token.admin == true);
                   
      // Uncommitted drafts edited in the administrative preview
      match /drafts/{draftId} {
        allow read, write: if request.auth != null 
                           && (request.auth.token.siteId == siteId || request.auth.token.admin == true);
      }
    }
  }
}
```

## Firebase Storage Security Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    match /sites/{siteId}/{allPaths=**} {
      // Public read access for site visitors
      allow read: if true;
      
      // Upload/delete restricted to authorized operator of this specific site
      allow write: if request.auth != null 
                   && (request.auth.token.siteId == siteId || request.auth.token.admin == true)
                   && request.resource.size < 2 * 1024 * 1024
                   && request.resource.contentType.matches('image/(jpeg|png|webp)');
    }
  }
}
```

## Client Access Management

- Operators are provisioned via Firebase Auth using email and password.
- Upon provisioning, a custom claim `siteId: 'vila-chico-bento'` is attached to the user token.
- Upon client sign-in, the Flutter application validates the `siteId` claim to ensure cross-tenant operations are blocked at the client boundary.
