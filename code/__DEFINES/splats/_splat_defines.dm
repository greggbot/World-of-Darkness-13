
#define PURE_HUMAN_SPLAT (1<<0)
#define KINDRED_SPLAT (1<<1)
#define GHOUL_SPLAT (1<<2)
#define GAROU_SPLAT (1<<3)

// what splat are you?
#define splatted_kindred(A) (SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & KINDRED_SPLAT)
#define iskindred(A) (splatted_kindred(A))
#define splatted_ghoul(A) (SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & GHOUL_SPLAT)
#define isghoul(A) (splatted_ghoul(A))
#define splatted_garou(A) (SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & GAROU_SPLAT)
#define isgarou(A) (splatted_garou(A))
// we wanna account for stuff only humans can do, and also account for things like ghouled pets
#define splatted_pure_human(A) (SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & PURE_HUMAN_SPLAT)
#define is_pure_human(A) (splatted_pure_human(A))

#define iswerewolf(A) (istype(A, /mob/living/carbon/werewolf))

#define iscrinos(A) (istype(A, /mob/living/carbon/werewolf/crinos))

#define islupus(A) (istype(A, /mob/living/carbon/werewolf/lupus))
