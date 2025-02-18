SELECT 
    worker_id,
    phone_number,

    address->>'locality' AS address_locality,
    address->>'premises' AS address_premises,
    address->>'adminArea' AS address_admin_area,
    address->>'postalCode' AS address_postal_code,
    address->>'countryCode' AS address_country_code,
    address->>'countryName' AS address_country_name,
    address->>'subLocality' AS address_sub_locality,
    address->>'subAdminArea' AS address_sub_admin_area,
    address->>'thoroughfare' AS address_thoroughfare,
    
    profile->>'yob' AS profile_year_of_birth,
    profile->>'gender' AS profile_gender,
    profile->>'pincode' AS profile_pincode,
    profile->>'language' AS profile_language,
    profile->>'full_name' AS profile_full_name,
    profile->>'birth_year' AS profile_birth_year,
    profile->>'phone_number' AS profile_phone_number,
    profile->>'household_num' AS profile_household_num,
    profile->>'income_source' AS profile_income_source,
    profile->>'education_level' AS profile_education_level,
    profile->>'household_income' AS profile_household_income,
    profile->>'employment_status' AS profile_employment_status,
    profile->>'languages_selected' AS profile_languages_selected,

    baseline->'10677'->>'name' AS baseline_name,
    baseline->'10677'->>'last_name' AS baseline_last_name,
    baseline->'10677'->>'sleep_at' AS baseline_sleep_at,
    baseline->'10677'->>'wake_up_at' AS baseline_wake_up_at,
    baseline->'10677'->>'daily_activities' AS baseline_daily_activities,
    baseline->'10677'->>'number_of_son' AS baseline_number_of_son,
    baseline->'10677'->>'number_of_daughter' AS baseline_number_of_daughter,
    baseline->'10677'->>'own_education' AS baseline_own_education,
    baseline->'10677'->>'marital_status' AS baseline_marital_status,
    baseline->'10677'->>'no_of_children' AS baseline_no_of_children,
    baseline->'10677'->>'own_occupation' AS baseline_own_occupation,
    baseline->'10677'->>'wife_education' AS baseline_wife_education,
    baseline->'10677'->>'wife_occupation' AS baseline_wife_occupation,
    baseline->'10677'->>'birthplace_state' AS baseline_birthplace_state,
    baseline->'10677'->>'birthplace_district' AS baseline_birthplace_district,

    baseline->'10678'->>'social_media_impact' AS baseline_social_media_impact,
    baseline->'10678'->>'social_media_frequency' AS baseline_social_media_frequency,

    baseline->'10678'->>'consultation' AS baseline_consultation,
    baseline->'10678'->>'alone_friends' AS baseline_alone_friends,
    baseline->'10678'->>'market_permission' AS baseline_market_permission,
    baseline->'10678'->>'public_transportation' AS baseline_public_transportation,
    baseline->'10678'->>'clothing_purchase_permission' AS baseline_clothing_purchase_permission,
    baseline->'10678'->>'expensive_purchase' AS baseline_expensive_purchase,
    baseline->'10678'->>'friends_neighborhood' AS baseline_friends_neighborhood,

    baseline->'10678'->>'consultation_m' AS baseline_consultation_m,
    baseline->'10678'->>'alone_friends_m' AS baseline_alone_friends_m,
    baseline->'10678'->>'market_permission_m' AS baseline_market_permission_m,
    baseline->'10678'->>'public_transportation_m' AS baseline_public_transportation_m,
    baseline->'10678'->>'clothing_purchase_permission_m' AS baseline_clothing_purchase_permission_m,
    baseline->'10678'->>'expensive_purchase_m' AS baseline_expensive_purchase_m,
    baseline->'10678'->>'friends_neighborhood_m' AS baseline_friends_neighborhood_m,

    baseline->'10679'->>'statement_one' AS baseline_husband_failed_responsibility,
    baseline->'10679'->>'income_inequality' AS baseline_income_inequality,
    baseline->'10679'->>'statement_two_input' AS baseline_wife_failed_responsibility,
    baseline->'10679'->>'income_inequality_factor' AS baseline_income_inequality_factor
FROM (
    SELECT 
        baseline_data.worker_id,
        w.profile->'address' AS address,
        w.profile->'data' AS profile,
        w.phone_number AS phone_number,
        jsonb_object_agg(baseline_data.task_id, baseline_data.data) AS baseline
    FROM (
        SELECT 
            mta.worker_id, 
            mta.task_id, 
            mta.output->'data' AS data
        FROM 
            microtask_assignment mta 
        WHERE 
            mta.task_id IN ('10677', '10678', '10679')
            AND mta.status IN ('SUBMITTED', 'VERIFIED')
    ) baseline_data
    JOIN 
        worker w ON baseline_data.worker_id = w.id
    GROUP BY 
        baseline_data.worker_id, w.profile->'address', w.profile->'data', w.phone_number
) subquery;
