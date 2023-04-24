Feature: Web Interface STRIDE Security Requirements
    This feature file includes scenario outlines that test for STRIDE based controls that apply to web API endpoints.

    Rule: Only allowed ports

        Scenario Outline: Attacker Squatting on Server Port or Socket
            Test edge cases where an attacker squats on a nonstandard port

            Given the server is running
            And the server uses the specified <port>
            When an attacker with IP <attacker_ip> attempts to connect to a <requested_port> other than the expected one
            Then the server should <result> the connection
            And the server should log the event as <event>
            And the server should take appropriate action to prevent the squatting attempt

            Examples:
                | port     | requested_port | result    | event                                                                                                          | attacker_ip |
                | expected | unexpected     | Dropped   | "Port Squatting Detected: Attacker IP: <attacker_ip>, Requested Port: <requested_port>, Expected Port: <port>" | attacker_ip |
                | expected | expected       | Connected |                                                                                                                | attacker_ip |


    Rule: No unauthenticated access

        Scenario Outline: User Authentication
            The fundemental control to prevent spoofing is to ensure that the user is authenticated before allowing access.
            Given connection to <url>
            When connection from <ip>
            And using <protocol>
            And providing <token>
            And access should be <access>
            Then the interface should respond with <result>
            And Generate the following log <message>

            Examples:
                | url     | ip | protocol | token         | access  | result             | message                                          |
                | enpoint | ip | https    | valid_token   | granted | 200 OK             | "Login success, <ip>, <token.name>, <url>"       |
                | enpoint | ip | http     | valid_token   | denied  | 403 HTTPS Required | "HTTP access attempt, <ip>, <token.name>, <url>" |
                | enpoint | ip | https    | invalid_token | denied  | 401 Unauthorized   | "Login failure, <ip>, <token.name>, <url>"       |
                | enpoint | ip | https    | blank         | denied  | 401 Unauthorized   | "Login failure, <ip>, <token.name>, <url>"       |

    Rule: Only authorized individuals from authorized locations may access applications

        Scenario Outline: User Authorization
            Given the <user> from an <location>
            When attempts to access an <application> they are <status> access
            Then their access is <result>

            Examples:
                | user              | location              | application              | status     | result  |
                | authorized_user   | authorized_location   | authorized_application   | allowed    | granted |
                | authorized_user   | unauthorized_location | authorized_application   | disallowed | denied  |
                | authorized_user   | authorized_location   | unauthorized_application | allowed    | denied  |
                | authorized_user   | unauthorized_location | authorized_application   | allowed    | denied  |
                | authorized_user   | authorized_location   | unauthorized_application | disallowed | denied  |
                | authorized_user   | unauthorized_location | authorized_application   | disallowed | denied  |
                | authorized_user   | unauthorized_location | unauthorized_application | disallowed | denied  |
                | authorized_user   | unauthorized_location | unauthorized_application | allowed    | denied  |
                | unauthorized_user | authorized_location   | authorized_application   | allowed    | denied  |
                | unauthorized_user | unauthorized_location | authorized_application   | disallowed | denied  |
                | unauthorized_user | authorized_location   | unauthorized_application | allowed    | denied  |
                | unauthorized_user | unauthorized_location | authorized_application   | allowed    | denied  |
                | unauthorized_user | authorized_location   | unauthorized_application | disallowed | denied  |
                | unauthorized_user | unauthorized_location | authorized_application   | disallowed | denied  |
                | unauthorized_user | unauthorized_location | unauthorized_application | disallowed | denied  |
                | unauthorized_user | unauthorized_location | unauthorized_application | allowed    | denied  |

    Rule: All access attempts are monitored for anomolous activity

        Scenario Outline: Monitoring and alerting
            Given the <user>
            When <status> access <attempt> from a <loc_status> <location>
            Then their access generates a <log_msg>
            And <need-alert> genertates a <alert-msg>

            Examples:
                | user              | status  | attempts | loc_status | location         | log_msg                                 | need-alert | alert-msg                                                   |
                | authorized_user   | granted | 1        | known      | known_location   | '<user> granted access from <location>' | no         | 'none'                                                      |
                | authorized_user   | granted | 1        | new        | unknown_location | '<user> granted access from <location>' | yes        | '<user> granted access from a new location: <location>'     |
                | authorized_user   | denied  | 1        | known      | known_location   | '<user> failed access from <location>'  | no         | 'none'                                                      |
                | authorized_user   | denied  | 1        | new        | unknown_location | '<user> failed access from <location>'  | yes        | '<user> failed access from a new location: <location>'      |
                | authorized_user   | denied  | 10       | known      | known_location   | '<user> failed access from <location>'  | yes        | '<user> <attempts> failed access from location: <location>' |
                | unauthorized_user | denied  | 1        | any        | any_location     | '<user> denied access from <location>'  | no         | 'none'                                                      |
                | unauthorized_user | denied  | 10       | any        | any_location     | '<user> denied access from <location>'  | yes        | '<user> <attempts> failed access from location: <location>' |

    Rule: Ensure that the application only responds to secure protocols

        Scenario Outline: Encryption

            Given the <endpoint>
            When access is using <protocol>
            And protocol <version>
            Then the returned access is <result>

            Examples:
                | endpoint | protocol | version   | result               |
                | url      | http     | incorrect | 403 HTTPS Required   |
                | url      | https    | incorrect | 426 Upgrade Required |
                | url      | https    | correct   | 200 OK               |

    Rule: Ensure all data sent and received is valid

        Scenario Outline: Integrity
            Given an authenticated <user> and authorized connection <source> to a <endpoint>
            When <data> is received or sent
            And a <checksum> is available
            And each <data_element> is <formated>
            Then the transaction is <status>
            And Generate the following log <message>

            Examples:
                | user | source    | endpoint | data           | checksum         | data_element | formatted     | status   | message                                                                              |
                | user | source_ip | url      | welformed_data | valid_checksum   | data_element | well_formated | accepted | "Data Sent or received: <source>, <user>, <endpoint>, <data_element_name>, <status>" |
                | user | source_ip | url      | malformed_data | any              | data_element | well_formated | denied   | "Malformed Data: <source>, <user>, <endpoint>, <data_element_name>, <status>"        |
                | user | source_ip | url      | any            | invalid_checksum | data_element | well_formated | denied   | "Invalid Checksum: <source>, <user>, <endpoint>, <data_element_name>, <status>"      |


    Rule: Brute Force Attack Protection

        Scenario Outline: Blocking Brute Force Attacks
            Test for blocking brute force attacks with multiple credentials.  The expected behavior is two fold. The first is multiple failed attempts from a single username where the expected behavior
            is blocked for lockout_duration. The second is any access from a blocked attacker_ip for lockout_duration where the expected behavior is blocked for lockout_duration.

            Given the server is running
            And the server has a limit of <max_attempts> maximum login attempts per <time_period>
            And the server has a lockout duration of <lockout_duration> for failed login attempts
            When an attacker with IP <attacker_ip> fails to log in with <username> <max_attempts> times
            Then the server should respond with <result> the login attempt
            And the server should log the event as <event>

            Examples:
                | max_attempts | time_period | lockout_duration | username   | result                    | event                                                                                   | attacker_ip |
                | 3            | 5 minutes   | 15 minutes       | <username> | "This account is blocked" | "Brute Force Attack username Blocked: Attacker IP: <attacker_ip>, Username: <username>" | attacker_ip |
                | 3            | 5 minutes   | 15 minutes       | <any>      | "This account is blocked" | "Brute Force Attack Blocked: Attacker IP: <attacker_ip>, Username: <username>"          | attacker_ip |
