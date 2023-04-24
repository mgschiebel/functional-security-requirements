Feature: SMTP Server Configuration Testing
    This feature file includes scenario outlines that test for STRIDE based controls that apply to web API endpoints.

    Scenario Outline: Test SMTP server configuration for Spoofing threat with DMARC protection
        Given the SMTP server is running
        When an <user> connects from <ip> to send spoofed emails
        Then the SMTP server should <respond> based on DMARC
        Examples:
            | user              | ip           | response   |
            | trusted user      | malicious IP | quarantine |
            | unauthorized user | any IP       | reject     |
            | trusted user      | allowed IP   | accept     |



Feature: DKIM Protection for Email Tampering

    Scenario: Authorized Client Sends Legitimate and Tampered Email
        Given a mail server
        And a <client_type> client with <credentials> for <dns>
        And a valid DKIM <private_key>
        When the <client_type> client sends a <email> to a recipient
        Then the SMTP server provides the following <response>

        Examples:
            | client_type | credentials | dns         | private_key | email            | response                               |
            | Valid       | valid       | valid_dns   | valid       | legitimate email | 250 OK                                 |
            | Valid       | valid       | valid_dns   | valid       | tampered email   | 550 Message tampered                   |
            | Invalid     | valid       | invalid_dns | valid       | legitimate email | 250 OK                                 |
            | Invalid     | invalid     | invalid_dns | valid       | legitimate email | 535 Authentication credentials invalid |
            | Invalid     | valid       | invalid_dns | valid       | legitimate email | 250 OK                                 |
            | Invalid     | valid       | invalid_dns | invalid     | legitimate email | 554 DKIM signature invalid             |

    Scenario: Repudiation of Email by Authenticated Users Only
        Given a mail server
        And a <client_type> client with <credentials> for <dns>
        And a valid DKIM <private_key>
        When a <client_type> user sends an <email_type> email
        And the SMTP server receives the email
        Then the SMTP server provides the following <response> to the <user_type> user
        And the SMTP server logs the <log_message> for the <email_type> email

        Examples:
            | user_type       | email_type | response                    | log_message                                                 |
            | Authenticated   | legitimate | 250 OK                      | none                                                        |
            | Authenticated   | tampered   | 550 Message tampered        | "Sent tampered email from authenticated user"               |
            | Unauthenticated | legitimate | 530 Authentication required | "Failed to send legitimate email from unauthenticated user" |
            | Unauthenticated | tampered   | 530 Authentication required | "Failed to send tampered email from unauthenticated user"   |


    Scenario Outline: Test SMTP server configuration for Information Disclosure threat
        Given the SMTP server is running
        When an <attacker> attempts to retrieve email headers
        Then the SMTP server should restrict the Information Disclosure threat

        Examples:
            | attacker          |
            | unauthorized user |

    Scenario Outline: Test SMTP server configuration for Denial of Service threat
        Given the SMTP server is running
        When a <attacker> attempts to send a flood of emails
        Then the SMTP server should mitigate the Denial of Service threat

        Examples:
            | attacker |
            | botnet   |

    Scenario Outline: Test SMTP server configuration for Elevation of Privilege threat
        Given the SMTP server is running
        When a <attacker> attempts to gain admin access
        Then the SMTP server should restrict and log the Elevation of Privilege threat

        Examples:
            | attacker     |
            | trusted user |

