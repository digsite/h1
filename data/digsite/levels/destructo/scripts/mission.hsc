(global short global_alert_status 0)
(global long global_alert_timer (* 5.0 (* 60.0 900.0)))

(script startup mission_aria
    ;(ai_place bot_pit1)
    ;(ai_set_orders bot_pit1_init aria/bot_pit1_init_idle)
    ;(ai_set_orders bot_pit1_balcony aria/bot_pit1_balcony_combat)
    ;(ai_set_orders bot_pit1_hole aria/bot_pit1_hole_idle)
    (ai_place bot_pit2)
    (ai_place nsq_aria/bot_pit2_balcony_jackal)
    ;(ai_set_orders bot_pit2 aria/bot_pit2_idle)
    ;(ai_set_orders bot_pit2_balcony_jackal aria/bot_pit2_balcony)
    (sleep_until (volume_test_objects bot_pit1_hole_trigger (players)) 5)
    (ai_place mid_v_bot/mid_window_v_bot)
    (ai_place nsq_aria/mid_balcony1_v_bot)
    (ai_place nsq_aria/mid_balcony2_v_bot)
    ;(ai_set_orders mid_window_v_bot aria/mid_window_v_bot)
    ;(ai_set_orders nsq_aria/mid_balcony1_v_bot aria/mid_balocny1_v_bot)
    ;(ai_set_orders nsq_aria/mid_balcony2_v_bot aria/mid_balcony2_v_bot)
    (sleep_until 
        (or
            (and
                (volume_test_objects bot_stair_fat_trigger (players))
                (< (ai_living_count bot_pit2) 1)
            )
            (volume_test_objects bot_stair_trigger (players))
        ) 
    5)
    (ai_place mid_stair_v_bot/mid_stair_v_bot_grunt)
    (ai_place nsq_aria/mid_stair_v_bot_elite)
    ;(ai_set_orders mid_stair_v_bot_grunt aria/mid_stair_v_bot)
    ;(ai_set_orders mid_stair_v_bot_elite aria/mid_stair_v_bot)
    (ai_magically_see_players mid_stair_v_bot/mid_stair_v_bot_grunt)
    (sleep_until 
        (or
            (and
                (volume_test_objects bot_stair_trigger (players))
                (< (ai_living_count mid_stair_v_bot) 1)
            )
            (volume_test_objects mid_stair_trigger (players))
        ) 
    5)
    (ai_place nsq_aria/bot_stair_v_mid_jackal)
    ;(ai_set_orders bot_stair_v_mid_jackal aira/bot_stair_v_mid)
)

