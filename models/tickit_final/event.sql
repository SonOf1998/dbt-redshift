SELECT 
    *
FROM
    {{ ref('stg_event') }} e NATURAL JOIN {{ ref('stg_category') }} c
    
