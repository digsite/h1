;   Script:		Halo 2 Mission M1 Defense
;   Author:		Tyson
; Synopsis:		Defending a static point (the shield ship) from waves of 
;					Covenant attackers


;- Globals ---------------------------------------------------------------------

; Print useful debugging text
(global boolean debug true)

; Is it coop?
(global boolean coop false)

; Game phases
(global boolean begin_defense_phase FALSE)
(global boolean begin_retreat_phase FALSE)

; Magic numbers
(global short testing_save 5)
(global short ticks_per_minute 1800)


;- Cinematics ------------------------------------------------------------------

(script static void cinematic_insertion 
	(print "cinematic_insertion")
	(fade_in 0 0 0 0)
)

(script static void cinematic_extraction 
	(print "cinematic_extraction")
)

(script static void cinematic_orbital_attack
	; Shakey cam!
	(player_effect_set_max_rumble .5 0)
	(player_effect_set_max_rotation 0 0.3 0.3)

	; Fade in...
	(fade_out 1.0 1.0 1.0 10)
	(player_effect_start 1 0.3)

	; Hold it...
	(sleep 45)
	(print "*HISSS CRACKLE 'auuugh, Chief help me!' HISSSS*")
	
	; Fade it back in
	(fade_in 1.0 1.0 1.0 105)
	(player_effect_stop 2.5)
)


;- Game Save Checks ------------------------------------------------------------

; Save loop
(global boolean save_now false)
(script continuous save_loop
	(sleep_until save_now testing_save)
	(game_save_no_timeout)
	(set save_now false)
)

; Certain save subroutine
(script static void certain_save
	(set save_now true)
)


;- Dialog ----------------------------------------------------------------------

; Reinforcements
(script static void dialog_crew_01_request_reins
	(print "Crew 01> Looks like trouble here... we need some help.")
)
(script static void dialog_crew_02_request_reins
	(print "Crew 02> Looks like trouble here... we need some help.")
)
(script static void dialog_crew_03_request_reins
	(print "Crew 03> Looks like trouble here... we need some help.")
)
(script static void dialog_crew_04_request_reins
	(print "Crew 04> Looks like trouble here... we need some help.")
)

; Retreating
(script static void dialog_crew_01_retreating
	(print "Crew 01> There's too many! Falling back to ship!")
)
(script static void dialog_crew_02_retreating
	(print "Crew 02> There's too many! Falling back to ship!")
)
(script static void dialog_crew_03_retreating
	(print "Crew 03> There's too many! Falling back to ship!")
)
(script static void dialog_crew_04_retreating
	(print "Crew 04> There's too many! Falling back to ship!")
)


;- Vehicle Scripts -------------------------------------------------------------

(script static void RECORD
	(object_create_anew cd_inbound_02)
)


;- Covenant Dropship Wave 01

(script static void load_cd_01
	; Place the Covenant
	(ai_place cov_wave_01/cov_wave_01_drivers)

	; Place the ghosts
	(object_create cov_wave_01_ghost_01)
	(object_create cov_wave_01_ghost_02)
	
	; Load them with Covenant funz0rz!
	(vehicle_load_magic cov_wave_01_ghost_01 "G-driver" (unit (list_get (ai_actors cov_wave_01/cov_wave_01_drivers) 0)))
	(vehicle_load_magic cov_wave_01_ghost_02 "G-driver" (unit (list_get (ai_actors cov_wave_01/cov_wave_01_drivers) 1)))
	
	; Load them into the dropship
	(vehicle_load_magic cd_inbound_01 "cargo_ghost01" cov_wave_01_ghost_01)
	(vehicle_load_magic cd_inbound_01 "cargo_ghost03" cov_wave_01_ghost_02)
)

(script static void unload_cd_01
	; Place the passengers
	(ai_place cov_wave_01_infantry/cov_wave_01_scouts)
	(ai_place cov_wave_01_infantry/cov_wave_01_grunts)

	; Load up them just in time to unload them 
	(vehicle_load_magic cd_inbound_01 "CD-passengerL04" (unit (list_get (ai_actors cov_wave_01_infantry/cov_wave_01_scouts) 0)))
	(vehicle_load_magic cd_inbound_01 "CD-passengerL03" (unit (list_get (ai_actors cov_wave_01_infantry/cov_wave_01_scouts) 1)))
	(vehicle_load_magic cd_inbound_01 "passenger" (ai_actors cov_wave_01_infantry/cov_wave_01_grunts))

	; Drop the ghosts, give them orders
	(sleep 100)
	(vehicle_unload cd_inbound_01 "cargo")
	;(ai_set_orders cov_wave_01_drivers cov_wave_01/ghost_checkpoint_01)
	
	; Drop the scouts and grunts, give them orders
	(sleep 30)
	(vehicle_unload cd_inbound_01 "passenger")
	;(ai_set_orders cov_wave_01_scouts cov_wave_01/advance_rally_point_01)
	;(ai_set_orders cov_wave_01_grunts cov_wave_01/init)
	(sleep 70)
)

(script static void cd_inbound_01
	; Create and configure dropship
	(object_create_anew cd_inbound_01)
	(unit_close (unit cd_inbound_01))
	
	; Load dat mofo
	(load_cd_01)
	
	; Run the recording
	(recording_play cd_inbound_01 cd_inbound_01)
	(sleep (max 0 (- (recording_time cd_inbound_01) 1430)))
	(unit_open (unit cd_inbound_01))
	
	; Unload doze mofoz
	(unload_cd_01)
	
	; Continue on yo bad way
	(unit_close (unit cd_inbound_01))
	(sleep (recording_time cd_inbound_01))
	(object_destroy cd_inbound_01)

	; Word.
)

(script static void load_cd_01b
	(print "not loading anything...")
)

(script static void unload_cd_01b
	; Place the passengers
	(ai_place cov_wave_01_infantry/cov_wave_01b_scouts)
	(ai_place cov_wave_01_infantry/cov_wave_01b_grunts)
	
	; Load up them the bomb
	(vehicle_load_magic cd_inbound_01b "CD-passengerL04" (unit (list_get (ai_actors cov_wave_01_infantry/cov_wave_01b_scouts) 0)))
	(vehicle_load_magic cd_inbound_01b "CD-passengerL03" (unit (list_get (ai_actors cov_wave_01_infantry/cov_wave_01b_scouts) 1)))
	(vehicle_load_magic cd_inbound_01b "passenger" (ai_actors cov_wave_01_infantry/cov_wave_01b_grunts))

	; Drop the scouts and grunts, give them orders
	(sleep 90)
	(vehicle_unload cd_inbound_01b "passenger")
	;(ai_set_orders cov_wave_01b_scouts cov_wave_01/advance_rally_point_01)
	;(ai_set_orders cov_wave_01b_grunts cov_wave_01/init)
	(sleep 110)
)

(script static void cd_inbound_01b
	; Create and configure dropship
	(object_create_anew cd_inbound_01b)
	(unit_close (unit cd_inbound_01b))
	
	; Load dat mofo
	(load_cd_01b)
	
	; Run the recording
	(recording_play cd_inbound_01b cd_inbound_01)
	(sleep (max 0 (- (recording_time cd_inbound_01b) 1430)))
	(unit_open (unit cd_inbound_01b))
	
	; Unload doze mofoz
	(unload_cd_01b)
	
	; Continue on yo bad way
	(unit_close (unit cd_inbound_01b))
	(sleep (recording_time cd_inbound_01b))
	(object_destroy cd_inbound_01b)
)


; Wave 02

(script static void load_cd_02
	; Place the Covenant
	(ai_place cov_wave_01/cov_wave_02_drivers)

	; Place the ghosts
	(object_create cov_wave_02_ghost_01)
	(object_create cov_wave_02_ghost_02)
	
	; Load them with Covenant funz0rz!
	(vehicle_load_magic cov_wave_02_ghost_01 "G-driver" (unit (list_get (ai_actors cov_wave_01/cov_wave_02_drivers) 0)))
	(vehicle_load_magic cov_wave_02_ghost_02 "G-driver" (unit (list_get (ai_actors cov_wave_01/cov_wave_02_drivers) 1)))
	
	; Load them into the dropship
	(vehicle_load_magic cd_inbound_02 "cargo_ghost01" cov_wave_02_ghost_01)
	(vehicle_load_magic cd_inbound_02 "cargo_ghost03" cov_wave_02_ghost_02)
)

(script static void unload_cd_02
	; Place the passengers
	(ai_place cov_wave_01_infantry/cov_wave_02_scouts)
	(ai_place cov_wave_01_infantry/cov_wave_02_grunts)
	
	; Load up the rest of the covenant 
	(vehicle_load_magic cd_inbound_02 "CD-passengerL04" (unit (list_get (ai_actors cov_wave_01_infantry/cov_wave_02_scouts) 0)))
	(vehicle_load_magic cd_inbound_02 "CD-passengerL03" (unit (list_get (ai_actors cov_wave_01_infantry/cov_wave_02_scouts) 1)))
	(vehicle_load_magic cd_inbound_02 "passenger" (ai_actors cov_wave_01_infantry/cov_wave_02_grunts))

	; Drop the ghosts, give them orders
	(sleep 100)
	(vehicle_unload cd_inbound_02 "cargo")
	;(ai_set_orders cov_wave_02_drivers cov_wave_02/ghosts_init)
	
	; Drop the scouts and grunts, give them orders
	(sleep 30)
	(vehicle_unload cd_inbound_02 "passenger")
	;(ai_set_orders cov_wave_02_scouts cov_wave_02/rally_01)
	;(ai_set_orders cov_wave_02_grunts cov_wave_02/infantry_init)
	(sleep 70)
)

(script static void cd_inbound_02
	; Create and configure
	(object_create cd_inbound_02)
	(unit_close (unit cd_inbound_02))
	
	; Load dat mofo
	(load_cd_02)
	
	; Run the recording	
	(recording_play cd_inbound_02 cd_inbound_02)
	(sleep (max 0 (- (recording_time cd_inbound_02) 1520)))
	(unit_open (unit cd_inbound_02))
	
	; Unload mofoz
	(unload_cd_02)

	; Close and continue
	(unit_close (unit cd_inbound_02))
	(sleep (recording_time cd_inbound_02))
	(object_destroy cd_inbound_02)
)


;- Dropship Heavy Wave 01 ------------------------------------------------------

(script static void load_cd_heavy_01
	; Place the Covenant
	(ai_place nsq_cov_wave_01/cov_hwave_01_driver)
	(ai_place nsq_cov_wave_01/cov_hwave_01_infantry_01)
	(ai_place nsq_cov_wave_01/cov_hwave_01_infantry_02)

	; Place the ghosts
	(object_create cov_hwave_01_wraith)
	
	; Load it with Covenant funz0rz!
	(vehicle_load_magic cov_hwave_01_wraith "wraith-driver" (unit (list_get (ai_actors nsq_cov_wave_01/cov_hwave_01_driver) 0)))
	
	; Load it into the dropship
	(vehicle_load_magic cd_inbound_01 "cargo_wraith" cov_hwave_01_wraith)
	
	; Load up the rest of the covenant 
	(vehicle_load_magic cd_inbound_01 "CD-passengerL" (ai_actors nsq_cov_wave_01/cov_hwave_01_infantry_01))
	(vehicle_load_magic cd_inbound_01 "CD-passengerR" (ai_actors nsq_cov_wave_01/cov_hwave_01_infantry_02))
)

(script static void unload_cd_heavy_01
	; Drop the wraith, give it orders
	(sleep 100)
	(vehicle_unload cd_inbound_01 "cargo")
	;(ai_set_orders cov_hwave_01_driver cov_wave_01/wraith_init)
	
	; Drop the infantry, give them orders
	(vehicle_unload cd_inbound_01 "passenger")
	;(ai_set_orders cov_hwave_01_infantry_01 cov_wave_01/wraith_escort_left)
	;(ai_set_orders cov_hwave_01_infantry_02 cov_wave_01/wraith_escort_right)
	(sleep 100)
)

(script static void cd_heavy_inbound_01
	; Create and configure dropship
	(object_create_anew cd_inbound_01)
	(unit_close (unit cd_inbound_01))
	
	; Load dat mofo
	(load_cd_heavy_01)
	
	; Run the recording
	(recording_play cd_inbound_01 cd_inbound_01)
	(sleep (max 0 (- (recording_time cd_inbound_01) 1430)))
	(unit_open (unit cd_inbound_01))
	
	; Unload doze mofoz
	(unload_cd_heavy_01)
	
	; Continue on yo bad way
	(unit_close (unit cd_inbound_01))
	(sleep (recording_time cd_inbound_01))
	(object_destroy cd_inbound_01)
)


;- Human Snipers and ATVs ------------------------------------------------------

(global boolean sniper_atv_01_continue FALSE)
(script dormant sniper_atv_01
	(object_create_anew sniper_atv_01)
	(vehicle_load_magic sniper_atv_01 "M-driver" (list_get (ai_actors nsq_marine_snipers/marine_north_sniper) 0))
	(recording_play sniper_atv_01 sniper_atv_01_start)
	
	; Sleep till done, unload driver
	(sleep (recording_time sniper_atv_01))
	(if (not sniper_atv_01_continue) (unit_exit_vehicle (unit (list_get (ai_actors nsq_marine_snipers/marine_north_sniper) 0))))
	
	; Sleep until continue
	(sleep_until sniper_atv_01_continue 5)
	
	; If the sniper is dismounted...
	(if (not (vehicle_test_seat sniper_atv_01 "M-driver" (unit (list_get (ai_actors nsq_marine_snipers/marine_north_sniper) 0))))
		; If he is, MOUNT!
		(unit_enter_vehicle (unit (list_get (ai_actors nsq_marine_snipers/marine_north_sniper) 0)) sniper_atv_01 "M-driver")
	)
	
	; Sleep until the sniper is remounted
	(sleep_until (vehicle_test_seat sniper_atv_01 "M-driver" (unit (list_get (ai_actors nsq_marine_snipers/marine_north_sniper) 0))) 10)
	
	; Continue driving
	(object_teleport sniper_atv_01 sniper_atv_01_cont)
	(recording_play sniper_atv_01 sniper_atv_01_cont)
	
	; Sleep till finished, then exit
	(sleep (max 0 (- (recording_time sniper_atv_01) 30)))
	(unit_exit_vehicle (unit (list_get (ai_actors nsq_marine_snipers/marine_north_sniper) 0)))
	
	; Update their orders
	;(ai_set_orders marine_north_sniper marine_snipers/north_sniper)
)

(global boolean sniper_atv_02_continue FALSE)
(script dormant sniper_atv_02
	(object_create_anew sniper_atv_02)
	(vehicle_load_magic sniper_atv_02 "M-driver" (list_get (ai_actors nsq_marine_snipers/marine_south_sniper) 0))
	(recording_play sniper_atv_02 sniper_atv_02_start)
	
	; Sleep till done, unload driver
	(sleep (recording_time sniper_atv_02))
	(if (not sniper_atv_02_continue) (unit_exit_vehicle (unit (list_get (ai_actors nsq_marine_snipers/marine_south_sniper) 0))))
	
	; Sleep until continue
	(sleep_until sniper_atv_02_continue 5)
	
	; If the sniper is dismounted...
	(if (not (vehicle_test_seat sniper_atv_02 "M-driver" (unit (list_get (ai_actors nsq_marine_snipers/marine_south_sniper) 0))))
		; If he is, MOUNT!
		(unit_enter_vehicle (unit (list_get (ai_actors nsq_marine_snipers/marine_south_sniper) 0)) sniper_atv_02 "M-driver")
	)
	
	; Sleep until the sniper is remounted
	(sleep_until (vehicle_test_seat sniper_atv_02 "M-driver" (unit (list_get (ai_actors nsq_marine_snipers/marine_south_sniper) 0))) 10)
	
	; Continue driving
	(object_teleport sniper_atv_02 sniper_atv_02_cont)
	(recording_play sniper_atv_02 sniper_atv_02_cont)
	
	; Sleep till finished, then exit
	(sleep (max 0 (- (recording_time sniper_atv_02) 30)))
	(unit_exit_vehicle (unit (list_get (ai_actors nsq_marine_snipers/marine_south_sniper) 0)))
	
	; Update their orders
	;(ai_set_orders marine_south_sniper marine_snipers/south_sniper)
)

(script dormant initial_deploy_snipers
	(if debug (print "initial_deploy_snipers"))	
	
	; Place the snipers, give them orders
	(ai_place nsq_marine_snipers/marine_north_sniper)
	;(ai_set_orders marine_north_sniper marine_snipers/turret_interlude)
	(ai_place nsq_marine_snipers/marine_south_sniper)
	;(ai_set_orders marine_south_sniper marine_snipers/turret_interlude)

	; And run their deployment scripts
	(wake sniper_atv_01)
	(wake sniper_atv_02)
	
	; Sleep for a minute, and then force an advance
	(sleep 1800)
	(set sniper_atv_01_continue TRUE)
	(set sniper_atv_02_continue TRUE)
)


;- Perimeter Warthogs ----------------------------------------------------------

; Crew units
(global unit swap_unit null_unit)
(global unit crew01_driver null_unit)
(global unit crew01_gunner null_unit)
(global unit crew01_passenger null_unit)
(global unit crew02_driver null_unit)
(global unit crew02_gunner null_unit)
(global unit crew02_passenger null_unit)
(global unit crew03_driver null_unit)
(global unit crew03_gunner null_unit)
(global unit crew03_passenger null_unit)
(global unit crew04_driver null_unit)
(global unit crew04_gunner null_unit)
(global unit crew04_passenger null_unit)

(global boolean crew01_retreated FALSE)
(global boolean crew02_retreated FALSE)
(global boolean crew03_retreated FALSE)
(global boolean crew04_retreated FALSE)


; Perimeter Warthog 01
; Ich bin der ubermench
(script static void perimeter_warthog_01_start
	; Place the drivers, load them into the variables, set their orders
	(ai_place marine_perimeter_crews/marine_perimeter_crew_01)
	(set crew01_driver (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_01) 0)))
	(set crew01_gunner (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_01) 1)))
	(set crew01_passenger (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_01) 2)))
	;(ai_set_orders marine_perimeter_crew_01 marine_annex/warthog_01_init)

	; Create the hog
	(object_create perimeter_warthog_01)
	(unit_set_enterable_by_player perimeter_warthog_01 false)
	
	; Load the hog
	(vehicle_load_magic perimeter_warthog_01 "W-driver" crew01_driver)
	(vehicle_load_magic perimeter_warthog_01 "W-gunner" crew01_gunner)
	(recording_play perimeter_warthog_01 perimeter_warthog_01_start)
	
	; Sleep until done, then make the driver get out
	(sleep (max 0 (- (recording_time perimeter_warthog_01) 30)))
	(unit_exit_vehicle crew01_driver)
)

(script static void handle_crew01_casualties
	; Handle casualties
	(if (<= (unit_get_health crew01_driver) 0.0)
		; The driver is dead. Check if the passenger is also dead
		(if (<= (unit_get_health crew01_passenger) 0.0)
			; The passenger is also dead. Check if the gunner is dead
			(if (<= (unit_get_health crew01_gunner) 0.0)
				; The gunner was also dead. Print a notificiation for my edification
				(if debug (print "crew01 all dead"))
				
				; The gunner is not dead, so promote him to the driver, demote (dead) driver to gunner, and make him get out too
				(begin
					(unit_exit_vehicle crew01_gunner)
					(set swap_unit crew01_driver)
					(set crew01_driver crew01_gunner)
					(set crew01_gunner swap_unit)
				)
			)
			
			; The passenger was alive, promote him to driver, demote (dead) driver to passenger
			(begin
				(set swap_unit crew01_driver)
				(set crew01_driver crew01_passenger)
				(set crew01_passenger swap_unit)
			)
		)
		
		; The driver is not dead. Check if the gunner is dead
		(if (<= (unit_get_health crew01_gunner) 0.0)
			; He is dead, so swap him with the passenger (if the passenger is alive)
			(if (> (unit_get_health crew01_passenger) 0.0)
				(begin
					(set swap_unit crew01_gunner)
					(set crew01_gunner crew01_passenger)
					(set crew01_passenger swap_unit)
				)
			)
		)
	)
	
	; Sanity check
	(if (<= (unit_get_health crew01_driver) 0.0) (set crew01_driver null_unit))
	(if (<= (unit_get_health crew01_gunner) 0.0) (set crew01_gunner null_unit))
	(if (<= (unit_get_health crew01_passenger) 0.0) (set crew01_passenger null_unit))
)

(script static void load_crew01 
	; Load the driver if he's alive
	(if (> (unit_get_health crew01_driver) 0.0)
		(unit_enter_vehicle crew01_driver perimeter_warthog_01 "W-driver")
	)

	; Load the gunner if he is alive and isn't already loaded
	(if (not (vehicle_test_seat perimeter_warthog_01 "W-gunner" crew01_gunner)) 
		(if (> (unit_get_health crew01_gunner) 0.0)
			(unit_enter_vehicle crew01_gunner perimeter_warthog_01 "W-gunner")
		)
	)
	
	; Load the passenger
	(if (> (unit_get_health crew01_passenger) 0.0)	
		(unit_enter_vehicle crew01_passenger perimeter_warthog_01 "W-passenger")
	)

	; Sleep until the driver and passenger are loaded
	(sleep_until
		(and
			; Driver is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_01 "W-driver" crew01_driver)
				(<= (unit_get_health crew01_driver) 0.0)
			)
			; Gunner is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_01 "W-gunner" crew01_gunner)
				(<= (unit_get_health crew01_gunner) 0.0)
			)
			; Passenger is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_01 "W-passenger" crew01_passenger)
				(<= (unit_get_health crew01_passenger) 0.0)
			)
		)
	)
)

(global boolean perimeter_warthog_01_continue FALSE)
(script dormant perimeter_warthog_01
	; Place the crews, start the hogs
	(perimeter_warthog_01_start) 
	
	; Sleep until should continue
	(sleep_until perimeter_warthog_01_continue)
	
	; Handle casualties and load up
	(handle_crew01_casualties)
	(load_crew01)
		
	; Continue on your way if there is a crew left alive
	(if (> (ai_living_count marine_perimeter_crews/marine_perimeter_crew_01) 0)
		(begin
			; Teleport to the flag, and run the recording
			(object_teleport perimeter_warthog_01 perimeter_warthog_01_cont)
			(recording_play perimeter_warthog_01 perimeter_warthog_01_cont)
		
			; Sleep until done, then make the driver and passenger get out
			(sleep (max 0 (- (recording_time perimeter_warthog_01) 30)))
			(unit_exit_vehicle crew01_driver)
			(unit_exit_vehicle crew01_passenger)
			
			; Update their orders
			;(ai_set_orders marine_perimeter_crew_01 marine_perimeter_01/init)
		)
	)
)

(script dormant warthog_01_retreat_thread
	; Mark them as having retreated
	(set crew01_retreated TRUE)

	; Handle casualties and load up
	(handle_crew01_casualties)
	(load_crew01)
		
	; If the driver is in his seat, drive!
	(if (vehicle_test_seat perimeter_warthog_01 "W-driver" crew01_driver)
		; Drive!
		(begin
			(object_teleport perimeter_warthog_01 perimeter_warthog_01_retreat)
			(recording_play perimeter_warthog_01 perimeter_warthog_01_retreat)
		)
	)
)
(script static void perimeter_warthog_01_retreat
	(wake warthog_01_retreat_thread)
	(dialog_crew_01_retreating)
)


; Perimeter Warthog 02
; Ja, ist gut
(script static void perimeter_warthog_02_start
	; Place the drivers, load them into the variables, set their orders
	(ai_place marine_perimeter_crews/marine_perimeter_crew_02)
	(set crew02_driver (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_02) 0)))
	(set crew02_gunner (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_02) 1)))
	(set crew02_passenger (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_02) 2)))
	;(ai_set_orders marine_perimeter_crew_02 marine_annex/warthog_02_init)

	; Create the hog
	(object_create perimeter_warthog_02)
	(unit_set_enterable_by_player perimeter_warthog_02 false)
	
	; Load the hog
	(vehicle_load_magic perimeter_warthog_02 "W-driver" crew02_driver)
	(vehicle_load_magic perimeter_warthog_02 "W-gunner" crew02_gunner)
	(recording_play perimeter_warthog_02 perimeter_warthog_02_start)
	
	; Sleep until done, then make the driver get out
	(sleep (max 0 (- (recording_time perimeter_warthog_02) 30)))
	(unit_exit_vehicle crew02_driver)
)

(script static void handle_crew02_casualties
	; Handle casualties
	(if (<= (unit_get_health crew02_driver) 0.0)
		; The driver is dead. Check if the passenger is also dead
		(if (<= (unit_get_health crew02_passenger) 0.0)
			; The passenger is also dead. Check if the gunner is dead
			(if (<= (unit_get_health crew02_gunner) 0.0)
				; The gunner was also dead. Print a notificiation for my edification
				(if debug (print "crew02 all dead"))
				
				; The gunner is not dead, so promote him to the driver, demote (dead) driver to gunner, and make him get out too
				(begin
					(unit_exit_vehicle crew02_gunner)
					(set swap_unit crew02_driver)
					(set crew02_driver crew02_gunner)
					(set crew02_gunner swap_unit)
				)
			)
			
			; The passenger was alive, promote him to driver, demote (dead) driver to passenger
			(begin
				(set swap_unit crew02_driver)
				(set crew02_driver crew02_passenger)
				(set crew02_passenger swap_unit)
			)
		)
		
		; The driver is not dead. Check if the gunner is dead
		(if (<= (unit_get_health crew02_gunner) 0.0)
			; He is dead, so swap him with the passenger (if the passenger is alive)
			(if (> (unit_get_health crew02_passenger) 0.0)
				(begin
					(set swap_unit crew02_gunner)
					(set crew02_gunner crew02_passenger)
					(set crew02_passenger swap_unit)
				)
			)
		)
	)
	
	; Sanity check
	(if (<= (unit_get_health crew02_driver) 0.0) (set crew02_driver null_unit))
	(if (<= (unit_get_health crew02_gunner) 0.0) (set crew02_gunner null_unit))
	(if (<= (unit_get_health crew02_passenger) 0.0) (set crew02_passenger null_unit))
)

(script static void load_crew02
	; Load the driver if he's alive
	(if (> (unit_get_health crew02_driver) 0.0)
		(unit_enter_vehicle crew02_driver perimeter_warthog_02 "W-driver")
	)

	; Load the gunner if he is alive and isn't already loaded
	(if (not (vehicle_test_seat perimeter_warthog_02 "W-gunner" crew02_gunner)) 
		(if (> (unit_get_health crew02_gunner) 0.0)
			(unit_enter_vehicle crew02_gunner perimeter_warthog_02 "W-gunner")
		)
	)
	
	; Load the passenger
	(if (> (unit_get_health crew02_passenger) 0.0)	
		(unit_enter_vehicle crew02_passenger perimeter_warthog_02 "W-passenger")
	)

	; Sleep until the driver and passenger are loaded
	(sleep_until
		(and
			; Driver is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_02 "W-driver" crew02_driver)
				(<= (unit_get_health crew02_driver) 0.0)
			)
			; Gunner is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_02 "W-gunner" crew02_gunner)
				(<= (unit_get_health crew02_gunner) 0.0)
			)
			; Passenger is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_02 "W-passenger" crew02_passenger)
				(<= (unit_get_health crew02_passenger) 0.0)
			)
		)
	)
)

(global boolean perimeter_warthog_02_continue FALSE)
(script dormant perimeter_warthog_02
	; Place the crews, start the hogs
	(perimeter_warthog_02_start) 
	
	; Sleep until should continue
	(sleep_until perimeter_warthog_02_continue)
	
	; Handle casualties and load up
	(handle_crew02_casualties)
	(load_crew02)
	
	; Continue on your way if there is a crew left alive
	(if (> (ai_living_count marine_perimeter_crews/marine_perimeter_crew_02) 0)
		(begin
			; Teleport to the flag, and run the recording
			(object_teleport perimeter_warthog_02 perimeter_warthog_02_cont)
			(recording_play perimeter_warthog_02 perimeter_warthog_02_cont)
		
			; Sleep until done, then make the driver and passenger get out
			(sleep (max 0 (- (recording_time perimeter_warthog_02) 30)))
			(unit_exit_vehicle crew02_driver)
			(unit_exit_vehicle crew02_passenger)

			; Update their orders
			;(ai_set_orders marine_perimeter_crew_02 marine_perimeter_02/init)
		)
	)
)

(script dormant warthog_02_retreat_thread
	; Mark them as having retreated
	(set crew02_retreated TRUE)

	; Handle casualties and load up
	(handle_crew02_casualties)
	(load_crew02)
		
	; If the driver is in his seat, drive!
	(if (vehicle_test_seat perimeter_warthog_02 "W-driver" crew02_driver)
		; Drive!
		(begin
			(object_teleport perimeter_warthog_02 perimeter_warthog_02_retreat)
			(recording_play perimeter_warthog_02 perimeter_warthog_02_retreat)
		)
	)
)
(script static void perimeter_warthog_02_retreat
	(wake warthog_02_retreat_thread)
	(dialog_crew_02_retreating)
)


; Perimeter Warthog 03

(script dormant perimeter_warthog_03
	(if debug (print "perimeter_warthog_03"))
	; Place the ai and set the globals 
	(ai_place marine_perimeter_crews/marine_perimeter_crew_03)
	(set crew03_driver (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_03) 0)))
	(set crew03_gunner (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_03) 1)))
	(set crew03_passenger (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_03) 2)))

	; Create and load the hog
	(object_create perimeter_warthog_03)
	(unit_set_enterable_by_player perimeter_warthog_03 false)
	(vehicle_load_magic perimeter_warthog_03 "W-driver" crew03_driver)
	(vehicle_load_magic perimeter_warthog_03 "W-gunner" crew03_gunner)
	(vehicle_load_magic perimeter_warthog_03 "W-passenger" crew03_passenger)
	(recording_play perimeter_warthog_03 perimeter_warthog_03)
	
	; Sleep until done, then make the driver get out
	(sleep (max 0 (- (recording_time perimeter_warthog_03) 30)))
	(unit_exit_vehicle crew03_driver)
	(unit_exit_vehicle crew03_passenger)

	; Update their orders
	;(ai_set_orders marine_perimeter_crew_03 marine_perimeter_03/init)
)

(script static void handle_crew03_casualties
	(if debug (print "handle_crew03_casualties"))
	; Handle casualties
	(if (<= (unit_get_health crew03_driver) 0.0)
		; The driver is dead. Check if the passenger is also dead
		(if (<= (unit_get_health crew03_passenger) 0.0)
			; The passenger is also dead. Check if the gunner is dead
			(if (<= (unit_get_health crew03_gunner) 0.0)
				; The gunner was also dead. Print a notificiation for my edification
				(if debug (print "crew03 all dead"))
				
				; The gunner is not dead, so promote him to the driver, demote (dead) driver to gunner, and make him get out too
				(begin
					(unit_exit_vehicle crew03_gunner)
					(set swap_unit crew03_driver)
					(set crew03_driver crew03_gunner)
					(set crew03_gunner swap_unit)
				)
			)
			
			; The passenger was alive, promote him to driver, demote (dead) driver to passenger
			(begin
				(set swap_unit crew03_driver)
				(set crew03_driver crew03_passenger)
				(set crew03_passenger swap_unit)
			)
		)
		
		; The driver is not dead. Check if the gunner is dead
		(if (<= (unit_get_health crew03_gunner) 0.0)
			; He is dead, so swap him with the passenger (if the passenger is alive)
			(if (> (unit_get_health crew03_passenger) 0.0)
				(begin
					(set swap_unit crew03_gunner)
					(set crew03_gunner crew03_passenger)
					(set crew03_passenger swap_unit)
				)
			)
		)
	)
	
	; Sanity check
	(if (<= (unit_get_health crew03_driver) 0.0) (set crew03_driver null_unit))
	(if (<= (unit_get_health crew03_gunner) 0.0) (set crew03_gunner null_unit))
	(if (<= (unit_get_health crew03_passenger) 0.0) (set crew03_passenger null_unit))
)

(script static void load_crew03
	; Load the driver if he's alive
	(if (> (unit_get_health crew03_driver) 0.0)
		(unit_enter_vehicle crew03_driver perimeter_warthog_03 "W-driver")
	)

	; Load the gunner if he is alive and isn't already loaded
	(if (not (vehicle_test_seat perimeter_warthog_03 "W-gunner" crew03_gunner)) 
		(if (> (unit_get_health crew03_gunner) 0.0)
			(unit_enter_vehicle crew03_gunner perimeter_warthog_03 "W-gunner")
		)
	)

	; Load the passenger
	(if (> (unit_get_health crew03_passenger) 0.0)	
		(unit_enter_vehicle crew03_passenger perimeter_warthog_03 "W-passenger")
	)

	; Sleep until the driver and passenger are loaded
	(sleep_until
		(and
			; Driver is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_03 "W-driver" crew03_driver)
				(<= (unit_get_health crew03_driver) 0.01)
			)
			; Gunner is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_03 "W-gunner" crew03_gunner)
				(<= (unit_get_health crew03_gunner) 0.01)
			)
			; Passenger is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_03 "W-passenger" crew03_passenger)
				(<= (unit_get_health crew03_passenger) 0.01)
			)
		)
	)
)

(script dormant warthog_03_retreat_thread
	; Mark them as having retreated
	(set crew03_retreated TRUE)

	; Handle casualties and load up
	(handle_crew03_casualties)
	(load_crew03)
		
	; If the driver is in his seat, drive!
	(if (vehicle_test_seat perimeter_warthog_03 "W-driver" crew03_driver)
		; Drive!
		(begin
			(object_teleport perimeter_warthog_03 perimeter_warthog_03_retreat)
			(recording_play perimeter_warthog_03 perimeter_warthog_03_retreat)
		)
	)
)
(script static void perimeter_warthog_03_retreat
	(wake warthog_03_retreat_thread)
	(dialog_crew_03_retreating)
)


; Perimeter Warthog 04
; Das Warthog, ist gut! Ja!
(script dormant perimeter_warthog_04
	; Place the ai
	(ai_place marine_perimeter_crews/marine_perimeter_crew_04)
	(set crew04_driver (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_04) 0)))
	(set crew04_gunner (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_04) 1)))
	(set crew04_passenger (unit (list_get (ai_actors marine_perimeter_crews/marine_perimeter_crew_04) 2)))

	; Create and load the hog
	(object_create perimeter_warthog_04)
	(unit_set_enterable_by_player perimeter_warthog_04 false)
	(vehicle_load_magic perimeter_warthog_04 "W-driver" crew04_driver)
	(vehicle_load_magic perimeter_warthog_04 "W-gunner" crew04_gunner)
	(vehicle_load_magic perimeter_warthog_04 "W-passenger" crew04_passenger)
	(recording_play perimeter_warthog_04 perimeter_warthog_04)

	; Sleep until done, then make the driver get out
	(sleep (max 0 (- (recording_time perimeter_warthog_04) 30)))
	(unit_exit_vehicle crew04_driver)
	(unit_exit_vehicle crew04_passenger)

	; Update their orders
	;(ai_set_orders marine_perimeter_crew_04 marine_perimeter_04/init)
)

(script static void handle_crew04_casualties
	(if debug (print "handle_crew04_casualties"))
	; Handle casualties
	(if (<= (unit_get_health crew04_driver) 0.0)
		; The driver is dead. Check if the passenger is also dead
		(if (<= (unit_get_health crew04_passenger) 0.0)
			; The passenger is also dead. Check if the gunner is dead
			(if (<= (unit_get_health crew04_gunner) 0.0)
				; The gunner was also dead. Print a notificiation for my edification
				(if debug (print "crew04 all dead"))
				
				; The gunner is not dead, so promote him to the driver, demote (dead) driver to gunner, and make him get out too
				(begin
					(unit_exit_vehicle crew04_gunner)
					(set swap_unit crew04_driver)
					(set crew04_driver crew04_gunner)
					(set crew04_gunner swap_unit)
				)
			)
			
			; The passenger was alive, promote him to driver, demote (dead) driver to passenger
			(begin
				(set swap_unit crew04_driver)
				(set crew04_driver crew04_passenger)
				(set crew04_passenger swap_unit)
			)
		)
		
		; The driver is not dead. Check if the gunner is dead
		(if (<= (unit_get_health crew04_gunner) 0.0)
			; He is dead, so swap him with the passenger (if the passenger is alive)
			(if (> (unit_get_health crew04_passenger) 0.0)
				(begin
					(set swap_unit crew04_gunner)
					(set crew04_gunner crew03_passenger)
					(set crew04_passenger swap_unit)
				)
			)
		)
	)
	
	; Sanity check
	(if (<= (unit_get_health crew04_driver) 0.0) (set crew04_driver null_unit))
	(if (<= (unit_get_health crew04_gunner) 0.0) (set crew04_gunner null_unit))
	(if (<= (unit_get_health crew04_passenger) 0.0) (set crew04_passenger null_unit))
)

(script static void load_crew04
	; Load the driver if he's alive
	(if (> (unit_get_health crew04_driver) 0.0)
		(unit_enter_vehicle crew04_driver perimeter_warthog_04 "W-driver")
	)

	; Load the gunner if he is alive and isn't already loaded
	(if (not (vehicle_test_seat perimeter_warthog_04 "W-gunner" crew04_gunner)) 
		(if (> (unit_get_health crew04_gunner) 0.0)
			(unit_enter_vehicle crew04_gunner perimeter_warthog_04 "W-gunner")
		)
	)

	; Load the passenger
	(if (> (unit_get_health crew04_passenger) 0.0)	
		(unit_enter_vehicle crew04_passenger perimeter_warthog_04 "W-passenger")
	)

	; Sleep until the driver and passenger are loaded
	(sleep_until
		(and
			; Driver is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_04 "W-driver" crew04_driver)
				(<= (unit_get_health crew04_driver) 0.01)
			)
			; Gunner is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_04 "W-gunner" crew04_gunner)
				(<= (unit_get_health crew04_gunner) 0.01)
			)
			; Passenger is loaded or dead
			(or
				(vehicle_test_seat perimeter_warthog_04 "W-passenger" crew04_passenger)
				(<= (unit_get_health crew04_passenger) 0.01)
			)
		)
	)
)

(script dormant warthog_04_retreat_thread
	; Mark them as having retreated
	(set crew04_retreated TRUE)

	; Handle casualties and load up
	(handle_crew04_casualties)
	(load_crew04)
		
	; If the driver is in his seat, drive!
	(if (vehicle_test_seat perimeter_warthog_04 "W-driver" crew04_driver)
		; Drive!
		(begin
			(object_teleport perimeter_warthog_04 perimeter_warthog_04_retreat)
			(recording_play perimeter_warthog_04 perimeter_warthog_04_retreat)
		)
	)
)
(script static void perimeter_warthog_04_retreat
	(wake warthog_04_retreat_thread)
	(dialog_crew_04_retreating)
)


;- Other Human Vehicles --------------------------------------------------------

; Engineer warthogs
(script static void engineer_warthog_01
	(object_create engineer_warthog_01)
	(unit_set_enterable_by_player engineer_warthog_01 false)
	(vehicle_load_magic engineer_warthog_01 "W-driver" (list_get (ai_actors nsq_marine_engineer_drivers/marine_engineer_drivers) 0))
	(recording_play_and_delete engineer_warthog_01 engineer_warthog_01)
)

(script static void engineer_warthog_02
	(object_create engineer_warthog_02)
	(unit_set_enterable_by_player engineer_warthog_02 false)
	(vehicle_load_magic engineer_warthog_02 "W-driver" (list_get (ai_actors nsq_marine_engineer_drivers/marine_engineer_drivers) 1))
	(recording_play_and_delete engineer_warthog_02 engineer_warthog_02)
)

(script static void engineer_warthog_03
	(object_create engineer_warthog_03)
	(unit_set_enterable_by_player engineer_warthog_03 false)
	(vehicle_load_magic engineer_warthog_03 "W-driver" (list_get (ai_actors nsq_marine_engineer_drivers/marine_engineer_drivers) 2))
	(recording_play_and_delete engineer_warthog_03 engineer_warthog_03)
)

(script static void engineer_warthog_04
	(object_create engineer_warthog_04)
	(unit_set_enterable_by_player engineer_warthog_04 false)
	(vehicle_load_magic engineer_warthog_04 "W-driver" (list_get (ai_actors nsq_marine_engineer_drivers/marine_engineer_drivers) 3))
	(recording_play_and_delete engineer_warthog_04 engineer_warthog_04)
)

(script static void engineer_warthogs
	(if debug (print "engineer_warthogs"))
	; Place the drivers
	(ai_place nsq_marine_engineer_drivers/marine_engineer_drivers)
	(object_cannot_take_damage (ai_actors nsq_marine_engineer_drivers/marine_engineer_drivers))
	
	; Wake the driving scripts
	(engineer_warthog_01) 
	(sleep 30)
	(engineer_warthog_02) 
	(sleep 120)
	(engineer_warthog_03) 
	(sleep 50)
	(engineer_warthog_04) 
	
	; Wait for the last one to finish, then kill remaining drivers
	(sleep (recording_time engineer_warthog_04))
	(object_can_take_damage (ai_actors nsq_marine_engineer_drivers/marine_engineer_drivers))
	(ai_kill nsq_marine_engineer_drivers/marine_engineer_drivers)
)

;- Mission: Insertion ----------------------------------------------------------

; Enc01 - Annex defenders
; 	- Place covenant defenders
;	- Place an assault team of marines
;	- Begin deployment of the first two Warthog crews
(script dormant enc01_annex_defense
	(if debug (print "enc01_annex_defense"))
	(certain_save)
	
	; Make the south turret enterable
	(ai_vehicle_enterable_team south_sniper_turret covenant)
	(ai_vehicle_enterable_distance south_sniper_turret 4.0)
	
	; Place and order
	(ai_place cov_annex/cov_annex_elites)
	;(ai_set_orders cov_annex_elites cov_annex/guard_tower)
	(ai_place cov_annex/cov_annex_tower)
	;(ai_set_orders cov_annex_tower cov_annex/tower)
	(ai_place cov_annex/cov_annex_turret)
	;(ai_set_orders cov_annex_turret cov_annex/man_turret)
	(ai_place cov_annex_grunts/cov_annex_grunts_01)
	;(ai_set_orders cov_annex_gruntscov_annex_grunts_01 cov_annex/guard_entrance_to_cower)
	(ai_place cov_annex_grunts/cov_annex_grunts_02)
	;(ai_set_orders cov_annex_grunts_02 cov_annex/guard_entrance_to_turret)
	
	; Place and order the assault team marines
	(ai_place nsq_marine_annex/marine_annex_assault_team)
	;(ai_set_orders marine_annex_assault_team marine_annex/assault_team_init)
	
	; Give some orders to the marines...
	(ai_try_to_fight marine_perimeter_crews/marine_perimeter_crew_01 cov_annex)
	(ai_try_to_fight marine_perimeter_crews/marine_perimeter_crew_02 cov_annex)
	
	; Deploy the warthogs
	(wake perimeter_warthog_01)
	(wake perimeter_warthog_02)
	
	; Sleep until the annex elites are mostly dead
	(sleep_until (<= (ai_living_count cov_annex/cov_annex_elites) 1) 30 300)
	
	; Send out the reinforcements
	(ai_place cov_annex/cov_annex_reinforcements)
	;(ai_set_orders cov_annex_reinforcements cov_annex/reinforcements)
	
	; Fight the reins for a bit
	(sleep_until (<= (ai_living_count cov_annex/cov_annex_reinforcements) 3))
	
	; Sleep until the annex elites are dead, with a timeout
	(sleep_until (<= (ai_living_count cov_annex/cov_annex_elites) 0))
	
	; Tell the warthogs to advance
	(set perimeter_warthog_01_continue TRUE)
	(set perimeter_warthog_02_continue TRUE)
	
	; Place and send out the other two warthogs
	(sleep 90)
	(wake perimeter_warthog_03)
	(wake perimeter_warthog_04)

	; Wait a few seconds, then deploy the snipers
	(sleep 300)
	(wake initial_deploy_snipers)
	
	; Wait until the snipers have been told to advance, then deploy the engineers
	; This way, those bloodthirsty bastards should run down fewer allies...
	(sleep 60)
	(sleep_until sniper_atv_01_continue)
	
	; Quick, while they're not looking! Begin the defense phase
	(set begin_defense_phase TRUE)
	
	; Do the orbital attack thing
	(sleep 300)
	(print "Attack imminent...")
	(sleep 200)
	
	; Do the attack
	(cinematic_orbital_attack)
	
	; Actually, wait longer to deply the engineers
	(sleep 450)
	(engineer_warthogs)
)


; Enc01 - Load Ghost with pilot
(script static void enc01_commandeer_ghost
	(if debug (print "enc01_load_ghost"))
	
	; If we have a driver still alive...
	;(if (< 0 (ai_living_count ai_current_squad))
		;(unit_enter_vehicle (unit (list_get (ai_actors ai_current_squad) 0)) annex_ghost_01 "G-driver")
	;)
	
	; If we have another driver still alive...
	;(if (< 1 (ai_living_count ai_current_squad))
		;(unit_enter_vehicle (unit (list_get (ai_actors ai_current_squad) 1)) annex_ghost_02 "G-driver")
	;)
)


; Enc01 - Turret captured, make it enterable by the marines
(script static void enc01_turret_captured
	(if debug (print "enc01_turret_captured"))	
	(ai_vehicle_enterable_team south_sniper_turret human)
	(ai_vehicle_enterable_distance south_sniper_turret 4.0)
	
	; Tell the snipers to continue on their merry way
	(set sniper_atv_01_continue TRUE)
	(set sniper_atv_02_continue TRUE)
)


; Trigger and clean
(script dormant mission_insertion_phase
	(if debug (print "mission_insertion_phase"))
	
	; Wake the annex encounter
	(wake enc01_annex_defense)
)
(script static void cleanup_insertion_phase
	(if debug (print "cleanup_insertion_phase"))
	(sleep -1 mission_insertion_phase)
)


;- Mission: Defense ------------------------------------------------------------

; Defense phase globals
(global boolean cov_wave_01_random_fork FALSE)
(global boolean cov_wave_02_random_fork FALSE)
(global boolean cov_wave_01b_should_begin FALSE)
(global boolean cov_wave_02b_should_begin FALSE)
(global boolean cov_wave_01_finished FALSE)
(global boolean cov_wave_02_finished FALSE)
(global boolean cov_hwave_01_finished FALSE)

; Cov Heavy Wave 01
;	- Create and place Covenant troops
;	- Make troops advance towards human positions
(script dormant cov_hwave_01_start
	(if debug (print "cov_hwave_01_start"))
	
	; Send in the first dropship
	(cd_heavy_inbound_01)
	
	; Sleep until the wraith is disabled or dead, then send in the backup
	(sleep_until (<= (ai_living_count nsq_cov_wave_01/cov_hwave_01_driver) 0))
	(set cov_hwave_01_finished TRUE)
)


; Cov Wave 02
;	- Create and place Covenant troops
;	- Make troops advance towards human positions
(script dormant cov_wave_02_start
	(if debug (print "cov_wave_02_start"))
	
	; Randomize the fork
	(begin_random
		(set cov_wave_02_random_fork FALSE)
		(set cov_wave_02_random_fork TRUE)		
	)
	
	; Send in the first dropship
	(cd_inbound_02)
	
	; Sleep until the scouts are dead, then send in the backup
	(sleep_until (<= (ai_living_count cov_wave_01_infantry/cov_wave_02_scouts) 0))
	(set cov_wave_02b_should_begin TRUE)
	
	(set cov_wave_02_finished TRUE)	
)


; Cov Wave 01b
;	- Create and place Covenant troops
;	- Make troops advance towards human positions
(script dormant cov_wave_01b_start
	; Debug spew
	(if debug (print "cov_wave_01b_start"))
	
	; Randomize the fork
	(begin_random
;		(set cov_wave_01_random_fork FALSE)
		(set cov_wave_01_random_fork TRUE)		
	)
	
	; Send in the first dropship
	(cd_inbound_01b)
	
	; Sleep until the scouts are dead, then send in the backup
	(sleep_until (<= (ai_living_count cov_wave_01_infantry/cov_wave_01b_scouts) 0))
	
	(set cov_wave_01_finished TRUE)	
)

; Cov Wave 01
;	- Create and place Covenant troops
;	- Make troops advance towards human positions
(script dormant cov_wave_01_start
	(if debug (print "cov_wave_01_start"))
	
	; Randomize the fork
	(begin_random
		(set cov_wave_01_random_fork FALSE)
		(set cov_wave_01_random_fork TRUE)		
	)
	
	; Send in the first dropship
	(cd_inbound_01)
	
	; Sleep until the scouts are dead, then send in the backup
	(sleep_until (<= (ai_living_count cov_wave_01_infantry/cov_wave_01_scouts) 0))
	(set cov_wave_01b_should_begin TRUE)
)

; Cov Wave 01 Fork
(script static boolean cov_wave_01_fork
	; Attack Warthog 01 if it returns TRUE--attack Warthog 03 if it returns FALSE
	; If Warthog 01 has retreated, never choose it (ie. always return FALSE)
	(and (= cov_wave_01_random_fork TRUE) (not crew01_retreated))
)
(script static boolean cov_wave_01_ghost_fork
	; Attack Warthog 01 if it returns TRUE--attack Warthog 03 if it returns FALSE
	; If Warthog 03 has retreated, never choose it (ie. always return TRUE)
	(or (= cov_wave_01_random_fork FALSE) crew01_retreated)
)

; Cov Wave 01 Checkpoints
;(script static boolean cov_wave_01_checkpoint_01
	;(volume_test_objects_all cov_wave_01_checkpoint_01 (ai_actors ai_current_squad))
;)
;(script static boolean cov_wave_01_rally_point_01
	;(volume_test_objects_all cov_wave_01_rally_point_01 (ai_actors ai_current_squad))
;)
;(script static boolean cov_wave_01_rally_point_02
	;(volume_test_objects_all cov_wave_01_rally_point_02 (ai_actors ai_current_squad))
;)
;(script static boolean cov_wave_01_warthog_01
	;(volume_test_objects_all cov_wave_01_warthog_01 (ai_actors ai_current_squad))
;)
;(script static boolean cov_wave_01_warthog_03
	;(volume_test_objects_all cov_wave_01_warthog_03 (ai_actors ai_current_squad))
;)
;(script static boolean cov_wave_01_rally_point_03
	;(volume_test_objects_all cov_wave_01_rally_point_03 (ai_actors ai_current_squad))
;)
;(script static boolean cov_hwave_01_rally_point_01
	;(volume_test_objects_all cov_hwave_01_rally_point_01 (ai_actors ai_current_squad))
;)
;(script static boolean cov_hwave_01_rally_vs_hogs
	;(volume_test_objects_all cov_hwave_01_attack_hogs (ai_actors ai_current_squad))
;)

; Routing conditions
(script static boolean cov_wave_01_rout_warthog_01
	(not (vehicle_test_seat_list perimeter_warthog_01 "W-gunner" (ai_actors marine_perimeter_crews/marine_perimeter_crew_01)))
)
(script static boolean cov_wave_02_rout_warthog_02
	(not (vehicle_test_seat_list perimeter_warthog_02 "W-gunner" (ai_actors marine_perimeter_crews/marine_perimeter_crew_02)))
)
(script static boolean cov_wave_01_rout_warthog_03
	(not (vehicle_test_seat_list perimeter_warthog_03 "W-gunner" (ai_actors marine_perimeter_crews/marine_perimeter_crew_03)))
)
(script static boolean cov_wave_02_rout_warthog_04
	(not (vehicle_test_seat_list perimeter_warthog_04 "W-gunner" (ai_actors marine_perimeter_crews/marine_perimeter_crew_04)))
)

; Some entry scripts
;(script static void cov_wave_01_reveal_warthog_01
	;(if (not crew01_retreated) (ai_magically_see_squads ai_current_squad marine_perimeter_crew_01))
;)
;(script static void cov_wave_01_reveal_warthog_03
	;(if (not crew03_retreated) (ai_magically_see_squads ai_current_squad marine_perimeter_crew_03))
;)

; Regrouping conditions
(script static boolean perimeter_crew_01_retreated
	(= crew01_retreated TRUE)
)
(script static boolean perimeter_crew_02_retreated
	(= crew02_retreated TRUE)
)
(script static boolean perimeter_crew_03_retreated
	(= crew03_retreated TRUE)
)
(script static boolean perimeter_crew_04_retreated
	(= crew04_retreated TRUE)
)


; Cov Wave 02 Rally Points
;(script static boolean cov_wave_02_rally_01
	;(volume_test_objects_all cov_wave_02_rally_01 (ai_actors ai_current_squad))
;)
;(script static boolean cov_wave_02_rally_02
	;(volume_test_objects_all cov_wave_02_rally_02 (ai_actors ai_current_squad))
;)
;(script static boolean cov_wave_02_rally_vs_hog_02
	;(volume_test_objects_all cov_wave_02_rally_vs_hog_02 (ai_actors ai_current_squad))
;)
;(script static boolean cov_wave_02_rally_vs_hog_04
	;(volume_test_objects_all cov_wave_02_rally_vs_hog_04 (ai_actors ai_current_squad))
;)

; Cov Wave 02 Fork
(script static boolean cov_wave_02_fork
	; Attack Warthog 02 if it returns TRUE--attack Warthog 04 if it returns FALSE
	; If Warthog 02 has retreated, always return FALSE
	(and (= cov_wave_02_random_fork TRUE) (not crew02_retreated))
)
(script static boolean cov_wave_02_ghost_fork
	; Attack Warthog 02 if it returns TRUE--attack Warthog 04 if it returns FALSE
	; If Warthog 04 has retreated, never choose it (ie. always return TRUE)
	(or (= cov_wave_02_random_fork FALSE) crew04_retreated)
)


; Trigger and clean
(script dormant mission_defense_phase
	; Sleep until the time is ripe
	(sleep_until begin_defense_phase)

	; Bit O Debug
	(if debug (print "mission_defense_phase"))
	
	; Clean up the previous phase
	(cleanup_insertion_phase)

	; Wake the waves on a random side
			(wake cov_wave_01_start)
			(sleep (* ticks_per_minute 2))
			(wake cov_wave_02_start)
			(sleep (* ticks_per_minute 2))
			(wake cov_wave_01b_start)
			(sleep (* ticks_per_minute 2))
;			(wake cov_wave_02b_start)
;			(sleep (* ticks_per_minute 3))

	; Do the heavy waves
	(begin_random
		(begin
			(wake cov_hwave_01_start)
			(sleep (* ticks_per_minute 3))
		)
;		(begin
;			(wake cov_wave_02_start)
;			(sleep (* ticks_per_minute 3))
;		)
	)
	

)
(script static void cleanup_defense_phase
	(if debug (print "cleanup_defense_phase"))
	(sleep -1 mission_defense_phase)
)


;- Mission: Retreat ------------------------------------------------------------

(script dormant mission_retreat_phase
	(if debug (print "mission_retreat_phase"))
	
	; Clean up the previous phase
	(cleanup_defense_phase)
)


(script static void cleanup_retreat_phase
	(if debug (print "cleanup_retreat_phase"))
	(sleep -1 mission_insertion_phase)
)


;- Entry Scripts ---------------------------------------------------------------

(script static void entry_test2
	(print "ENTERED ORDER!!")
)

(script static void entry_test
	(print "ENTERED ORDER!!")
)


;- Ending Condition Scripts ----------------------------------------------------

(script static boolean grenade_pulled
	(player_action_test_grenade_trigger)
)


;- Variant control -------------------------------------------------------------

; Test for coop, and if it is coop, adjust some globals
(script static void coop_control
	; Is it coop?
	(if (< (list_count (players)) 1)
		; It's coop
		(begin
			(if debug (print "Difficulty Adjusted for Coop"))
			(set coop true)
		)
	)
)


; Test for difficulty, adjust some globals
(script static void diff_control
	; Is it hard?
	(if (= "hard" (game_difficulty_get))
		; It's hard
		(begin
			(if debug (print "Difficulty Adjusted for Hard"))
		)
	)
	
	; Is it impossible?
	(if (= "impossible" (game_difficulty_get))
		; It's hard
		(begin
			(if debug (print "Difficulty Adjusted for Impossible"))
		)
	)
)


;- Main ------------------------------------------------------------------------

(global boolean cinematic_ran false)
(script startup mission
	; Fade to black
	(fade_out 0 0 0 0)
	
	; Variant control
	(coop_control)
	(diff_control)
	
	; Set some alliances (which the player will ignore anyway)
	(ai_allegiance human player)

	; Cinematics
	(if (cinematic_skip_start) 
		(begin
			(set cinematic_ran true)
			(cinematic_insertion)
		)
	)
	(cinematic_skip_stop)

	; Fade in if the cinematic hasn't done it already
	(if (not cinematic_ran)
		(fade_in 0 0 0 0)
	)
	
	; And here we go
	(wake mission_insertion_phase)
	(wake mission_defense_phase)
)


;- Cheat Scripts ---------------------------------------------------------------



