(script static void place_marines_support
    (ai_place "marines_support/marines_support_driver")
	(ai_place "marines_support/marines_support_gunner")
	(ai_place "marines_support/marines_support_passenger")
    ;(ai_set_orders "marines_assault" "red_base_vehicles/left")
)

(script static void load_marines_support
    (unit_enter_vehicle (unit (list_get (ai_actors "marines_support/marines_support_driver") 0)) "warthog_marines_support" "w-driver")
    (unit_enter_vehicle (unit (list_get (ai_actors "marines_support/marines_support_gunner") 0)) "warthog_marines_support" "w-gunner")
    (unit_enter_vehicle (unit (list_get (ai_actors "marines_support/marines_support_passenger") 0)) "warthog_marines_support" "w-passenger")
)

(script static void place_marines_assault
    (ai_place "marines_assault/marines_assault_driver")
	(ai_place "marines_assault/marines_assault_gunner")
	(ai_place "marines_assault/marines_assault_passenger")
    ;(ai_set_orders "marines_assault" "red_base_vehicles/right")
)

(script static void load_marines_assault
    (unit_enter_vehicle (unit (list_get (ai_actors "marines_assault/marines_assault_driver") 0)) "warthog_marines_assault" "w-driver")
    (unit_enter_vehicle (unit (list_get (ai_actors "marines_assault/marines_assault_gunner") 0)) "warthog_marines_assault" "w-gunner")
    (unit_enter_vehicle (unit (list_get (ai_actors "marines_assault/marines_assault_passenger") 0)) "warthog_marines_assault" "w-passenger")
)

(script static void place_covenant
    (ai_place "cov/cov_elites_base_top")
    ;(ai_set_orders "cov_elites_base_top" "red_base_infantry/def_top_front")
    (ai_place "cov/cov_elites_base_inner")
    ;(ai_set_orders "cov_elites_base_inner" "red_base_infantry/guard_front_rear")
    (ai_place "cov/cov_base_right")
    ;(ai_set_orders "cov_base_right" "red_base_infantry/guard_ground_right")
    (ai_place "cov/cov_base_left")
    ;(ai_set_orders "cov_base_left" "red_base_infantry/guard_ground_left")
)

(script startup main
    (print "startup")
	(ai_allegiance player human)
    (place_marines_support)
    (load_marines_support)
    (place_marines_assault)
    (load_marines_assault)
    (place_covenant)
)