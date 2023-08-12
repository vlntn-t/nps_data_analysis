WITH MonthlyVisits AS (
    SELECT
        u.company_id,
        COUNT(DISTINCT v.id) AS visits_last_30_days
    FROM
        users u
    JOIN
        visits v ON u.id = v.user_id
    WHERE
        v.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    GROUP BY
        u.company_id
),

PrevThreeMonthsVisits AS (
    SELECT
        u.company_id,
        COUNT(DISTINCT v.id) AS visits_prev_3_months
    FROM
        users u
    JOIN
        visits v ON u.id = v.user_id
    WHERE
        v.created_at >= DATE_SUB(NOW(), INTERVAL 3 MONTH) AND v.created_at < DATE_SUB(NOW(), INTERVAL 30 DAY)
    GROUP BY
        u.company_id
),

AverageVisits AS (
    SELECT
        u.company_id,
        AVG(v.visits_prev_3_months) AS avg_visits_prev_3_months
    FROM
        users u
    JOIN
        PrevThreeMonthsVisits v ON u.company_id = v.company_id
    GROUP BY
        u.company_id
)

SELECT
    c.id AS company_id,
    c.name AS company_name,
    GROUP_CONCAT(DISTINCT CASE WHEN u.Is_owner THEN u.email END SEPARATOR ', ') AS company_owners_emails,
    100 * (1 - mv.visits_last_30_days / av.avg_visits_prev_3_months) AS avg_percentage_drop,
    av.avg_visits_prev_3_months AS average_visits_prev_3_months,
    mv.visits_last_30_days AS visits_last_30_days,
    CASE WHEN 100 * (1 - mv.visits_last_30_days / av.avg_visits_prev_3_months) > 50 THEN 1 ELSE 0 END AS is_churn_risk
FROM
    companies c
JOIN
    users u ON c.id = u.company_id
JOIN
    MonthlyVisits mv ON c.id = mv.company_id
JOIN
    AverageVisits av ON c.id = av.company_id
GROUP BY
    c.id, c.name, av.avg_visits_prev_3_months, mv.visits_last_30_days;
