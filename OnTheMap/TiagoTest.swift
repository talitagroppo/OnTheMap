//
//  TiagoTest.swift
//  OnTheMap
//
//  Created by Talita Groppo on 25/01/2022.
//

import Foundation

struct UserResult: Decodable {
    let user: User
    struct User: Decodable {
        let last_name: String
        let social_accounts: [String]
        let mailing_address: String?
        let _cohort_keys: [String]
        let _signature: String?
        let _stripe_customer_id: String?
        let `guard`: GuardResult
        
        struct GuardResult: Decodable {
            let can_edit: Bool
            struct PermissionResult: Decodable {
                let derivation: [String]
                let behavior: String
                struct PrincipalRef: Decodable {
                    let ref: String
                    let key: String
                }
                let principal_ref: PrincipalRef
                }
            let permissions: [PermissionResult]
                
            let allowed_behaviors: [String]
            let subject_kind: String
        }
        let _facebook_id: String?
        let timezone: String?
        let site_preferences: String?
        let occupation: String?
        let _image: String?
        let first_name: String
        let jabber_id: String?
        let languages: String?
        let _badges: [String]
        let location: String?
        let external_service_password: String?
        let _principals: [String]
        let _enrollments: [String]
        
        struct Email: Decodable {
            let _verification_code_sent: Bool
            let _verified: Bool
            let address: String
        }
        
        let email: Email
        let website_url: String?
        let external_accounts:[String]?
        let bio: String?
        let coaching_data: String?
        let tags: [String]
        let _affiliate_profiles: [String]
        let _has_password: Bool
        let email_preferences: [EmailPreferences]
        
        struct EmailPreferences: Decodable{
            let ok_user_research: Bool
            let master_ok: Bool
            let ok_course: Bool
        }
        let _resume: String?
        let key: String
        let nickname: String
        let employer_sharing: Bool
        let memberships: [MemberShips]
        
        struct MemberShips: Decodable{
            let current: Bool
            let groupRef: [GroupRef]
            
            struct GroupRef: Decodable {
                let ref: String
                let key: String
                }
                let creation_time: String?
                let expiration_time: String?
            }
        let zendesk_id: String?
        let _registered: Bool
        let linkedin_url: String?
        let _google_id: String?
        let _image_url: String
    }
}

        

